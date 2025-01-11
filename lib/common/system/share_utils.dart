import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchment_delta/parchment_delta.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../actions/notes/add.dart';
import '../constants/constants.dart';
import '../models/note/note.dart';
import '../models/note/notes_types.dart';

/// Listens to any data shared from other applications.
StreamSubscription listenSharedData(WidgetRef ref) => ReceiveSharingIntent.instance.getMediaStream().listen((data) {
      _processSharedData(ref, data);
    });

/// Reads the data shared from other applications.
void readSharedData(WidgetRef ref) {
  ReceiveSharingIntent.instance.getInitialMedia().then((data) {
    _processSharedData(ref, data);

    ReceiveSharingIntent.instance.reset();
  });
}

/// Processes the [data] shared from other applications.
///
/// If the [data] is text, it's added to a new note that is then opened.
void _processSharedData(WidgetRef ref, List<SharedMediaFile> data) {
  if (rootNavigatorKey.currentContext == null ||
      data.isEmpty ||
      data.first.type != SharedMediaType.text ||
      data.first.path.isEmpty) {
    return;
  }

  final delta = Delta();
  for (final line in data.first.path.split('\n')) {
    delta.insert('$line\n');
  }

  final defaultShortcutNoteType = NoteType.defaultShortcutType;
  final context = rootNavigatorKey.currentContext!;
  final content = jsonEncode(delta);

  switch (defaultShortcutNoteType) {
    case NoteType.plainText:
      addNote<PlainTextNote>(context, ref, content: content);
    case NoteType.richText:
      addNote<RichTextNote>(context, ref, content: content);
  }
}
