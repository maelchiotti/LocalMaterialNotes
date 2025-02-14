import 'package:flutter/services.dart';

import '../../../models/note/note.dart';
import '../../constants/constants.dart';
import '../../ui/snack_bar_utils.dart';

/// Copies the content of the [note] to the clipboard.
Future<void> copyNote({required Note note}) async {
  Clipboard.setData(ClipboardData(text: note.contentPreview));

  SnackBarUtils.info(l.snack_bar_copied(1)).show();
}

/// Copies the content of the [notes] to the clipboard.
Future<void> copyNotes({required List<Note> notes}) async {
  final text = notes.map((note) => note.contentPreview).join('\n\n\n').trim();

  Clipboard.setData(ClipboardData(text: text));

  SnackBarUtils.info(l.snack_bar_copied(notes.length)).show();
}
