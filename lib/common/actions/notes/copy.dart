import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/note/note.dart';
import '../../extensions/build_context_extension.dart';
import '../../ui/snack_bar_utils.dart';
import '../authentication.dart';

/// Copies the content of the [note] to the clipboard.
///
/// Asks for authentication if the [note] requires it, unless the user [alreadyAuthenticated] (in the editor).
Future<void> copyNote(BuildContext context, {required Note note, bool alreadyAuthenticated = false}) async {
  if (!alreadyAuthenticated && !await authenticateIfRequired(context, [note])) {
    return;
  }

  await Clipboard.setData(ClipboardData(text: note.contentPreview));

  if (context.mounted) {
    SnackBarUtils().show(context, text: context.l.snack_bar_copied(1));
  }
}

/// Copies the content of the [notes] to the clipboard.
///
/// Asks for authentication if any of the [notes] requires it.
Future<void> copyNotes(BuildContext context, {required List<Note> notes}) async {
  if (!await authenticateIfRequired(context, notes)) {
    return;
  }

  final text = notes.map((note) => note.contentPreview).join('\n\n\n').trim();

  await Clipboard.setData(ClipboardData(text: text));

  if (context.mounted) {
    SnackBarUtils().show(context, text: context.l.snack_bar_copied(notes.length));
  }
}
