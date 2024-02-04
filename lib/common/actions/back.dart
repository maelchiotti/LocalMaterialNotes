import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/providers/current_note/current_note_provider.dart';
import 'package:localmaterialnotes/providers/editor_controller/editor_controller_provider.dart';

void back(BuildContext context) {
  context.pop();
}

void backFromEditor(BuildContext context, WidgetRef ref) {
  ref.read(currentNoteProvider.notifier).reset();
  ref.read(editorControllerProvider.notifier).unset();

  context.pop();
}
