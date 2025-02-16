import 'package:flutter/services.dart';

import '../../../models/note/note.dart';
import '../../constants/constants.dart';
import '../../ui/snack_bar_utils.dart';

/// Copies the content of the [note] to the clipboard.
Future<void> copyNote({required Note note}) async {
  await Clipboard.setData(ClipboardData(text: note.contentPreview));

  SnackBarUtils().show(text: l.snack_bar_copied(1));
}

/// Copies the content of the [notes] to the clipboard.
Future<void> copyNotes({required List<Note> notes}) async {
  final text = notes.map((note) => note.contentPreview).join('\n\n\n').trim();

  await Clipboard.setData(ClipboardData(text: text));

  SnackBarUtils().show(text: l.snack_bar_copied(notes.length));
}
