import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_format.dart';
import '../../extensions/build_context_extension.dart';
import '../../ui/snack_bar_utils.dart';
import '../authentication.dart';

/// Copies the title and the content of the [note] to the clipboard.
///
/// Asks for authentication if the [note] requires it, unless the user [alreadyAuthenticated] (in the editor).
Future<void> copyNote(BuildContext context, {required Note note, bool alreadyAuthenticated = false}) async {
  if (!alreadyAuthenticated && !await authenticateIfRequired(context, [note])) {
    return;
  }

  await Clipboard.setData(ClipboardData(text: NoteFormat.text.format(note)));

  if (context.mounted) {
    SnackBarUtils().show(context, text: context.l.snack_bar_copied(1));
  }
}

/// Copies the titles and the contents of the [notes] to the clipboard.
///
/// Asks for authentication if any of the [notes] requires it.
Future<void> copyNotes(BuildContext context, {required List<Note> notes}) async {
  if (!await authenticateIfRequired(context, notes)) {
    return;
  }

  final text = NoteFormat.text.formatAll(notes);

  await Clipboard.setData(ClipboardData(text: text));

  if (context.mounted) {
    SnackBarUtils().show(context, text: context.l.snack_bar_copied(notes.length));
  }
}
