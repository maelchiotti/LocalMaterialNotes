import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_format.dart';
import '../../extensions/build_context_extension.dart';
import '../../ui/snack_bar_utils.dart';
import '../../widgets/notes/note_format_sheet.dart';
import '../authentication.dart';

/// Copies the title and the content of the [note] to the clipboard.
///
/// Asks for authentication if the [note] requires it, unless the user [alreadyAuthenticated] (in the editor).
///
/// If [selectFormat] is `true`, asks the user for the format, otherwise copies it as plain text.
Future<void> copyNote(
  BuildContext context, {
  required Note note,
  bool alreadyAuthenticated = false,
  bool selectFormat = false,
}) async {
  if (!alreadyAuthenticated && !await authenticateIfRequired(context, [note])) {
    return;
  }

  if (!context.mounted) {
    return;
  }

  final format = await _format(context, selectFormat);

  if (format == null) {
    return;
  }

  await Clipboard.setData(ClipboardData(text: format.format(note)));

  if (context.mounted) {
    SnackBarUtils().show(context, text: context.l.snack_bar_copied(1));
  }
}

/// Copies the titles and the contents of the [notes] to the clipboard.
///
/// Asks for authentication if any of the [notes] requires it.
///
/// If [selectFormat] is `true`, asks the user for the format, otherwise copies them as plain text.
Future<void> copyNotes(BuildContext context, {required List<Note> notes, bool selectFormat = false}) async {
  if (!await authenticateIfRequired(context, notes)) {
    return;
  }

  if (!context.mounted) {
    return;
  }

  final format = await _format(context, selectFormat);

  if (format == null) {
    return;
  }

  await Clipboard.setData(ClipboardData(text: format.formatAll(notes)));

  if (context.mounted) {
    SnackBarUtils().show(context, text: context.l.snack_bar_copied(notes.length));
  }
}

/// Returns the format to copy the notes in: the one chosen by the user if [selectFormat], plain text otherwise.
Future<NoteFormat?> _format(BuildContext context, bool selectFormat) async {
  if (!selectFormat) {
    return NoteFormat.text;
  }

  final choice = await selectNoteFormat(context, title: context.l.note_format_copy_as);

  return choice?.format;
}
