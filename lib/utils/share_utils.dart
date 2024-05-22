import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/add.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:parchment_delta/parchment_delta.dart'; // ignore: depend_on_referenced_packages
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

StreamSubscription listenSharedData(WidgetRef ref) {
  return ReceiveSharingIntent.instance.getMediaStream().listen((data) {
    _processSharedData(ref, data);
  });
}

void readSharedData(WidgetRef ref) {
  ReceiveSharingIntent.instance.getInitialMedia().then((data) {
    _processSharedData(ref, data);

    ReceiveSharingIntent.instance.reset();
  });
}

void _processSharedData(WidgetRef ref, List<SharedMediaFile> data) {
  if (navigatorKey.currentContext == null ||
      data.isEmpty ||
      data.first.type != SharedMediaType.text ||
      data.first.path.isEmpty) {
    return;
  }

  final delta = Delta();
  for (final line in data.first.path.split('\n')) {
    delta.insert('$line\n');
  }

  addNote(navigatorKey.currentContext!, ref, content: jsonEncode(delta));
}
