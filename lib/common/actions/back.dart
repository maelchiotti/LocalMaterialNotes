import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

void back(BuildContext context) {
  context.pop();
}

void backFromEditor(BuildContext context, WidgetRef ref) {
  currentNoteNotifier.value = null;
  fleatherControllerNotifier.value = null;

  context.pop();
}
