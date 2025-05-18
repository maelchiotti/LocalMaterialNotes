import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/note/note.dart';
import '../../extensions/build_context_extension.dart';
import '../../ui/snack_bar_utils.dart';

/// Copies the content of the [note] to the clipboard.
Future<void> copyNote(BuildContext context, {required Note note}) async {
  await Clipboard.setData(ClipboardData(text: note.contentPreview));

  if (!context.mounted) {
    return;
  }

  if (context.mounted) {
    SnackBarUtils().show(context, text: context.l.snack_bar_copied(1));
  }
}

/// Copies the content of the [notes] to the clipboard.
Future<void> copyNotes(BuildContext context, {required List<Note> notes}) async {
  final text = notes.map((note) => note.contentPreview).join('\n\n\n').trim();

  await Clipboard.setData(ClipboardData(text: text));

  if (context.mounted) {
    SnackBarUtils().show(context, text: context.l.snack_bar_copied(notes.length));
  }
}
