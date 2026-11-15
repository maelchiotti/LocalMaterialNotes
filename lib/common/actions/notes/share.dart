import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_format.dart';
import '../../extensions/build_context_extension.dart';
import '../../widgets/notes/note_format_sheet.dart';
import '../authentication.dart';

/// Shares the [note] (title and content).
///
/// Asks for authentication if the [note] requires it, unless the user [alreadyAuthenticated] (in the editor).
///
/// If [selectFormat] is `true`, asks the user for the format, as text or as a file, otherwise shares it as plain text.
Future<void> shareNote(
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

  final choice = await _choice(context, selectFormat);

  if (choice == null) {
    return;
  }

  if (choice.asFile) {
    await _shareFiles([note], choice.format, subject: note.title);
  } else {
    await SharePlus.instance.share(ShareParams(text: choice.format.format(note), subject: note.title));
  }
}

/// Shares the [notes] (titles and contents).
///
/// As text, the notes are separated by dashes. As files, each note is shared in its own file.
///
/// Asks for authentication if any of the [notes] requires it.
///
/// If [selectFormat] is `true`, asks the user for the format, as text or as files, otherwise shares them as plain text.
Future<void> shareNotes(BuildContext context, {required List<Note> notes, bool selectFormat = false}) async {
  if (!await authenticateIfRequired(context, notes)) {
    return;
  }

  if (!context.mounted) {
    return;
  }

  final choice = await _choice(context, selectFormat);

  if (choice == null || !context.mounted) {
    return;
  }

  final subject = context.l.action_share_subject(notes.length);

  if (choice.asFile) {
    await _shareFiles(notes, choice.format, subject: subject);
  } else {
    await SharePlus.instance.share(ShareParams(text: choice.format.formatAll(notes), subject: subject));
  }
}

/// Returns how to share the notes: the choice of the user if [selectFormat], as plain text otherwise.
Future<NoteFormatChoice?> _choice(BuildContext context, bool selectFormat) async {
  if (!selectFormat) {
    return (format: NoteFormat.text, asFile: false);
  }

  return await selectNoteFormat(context, title: context.l.note_format_share_as, withFiles: true);
}

/// Shares the [notes] as files in the [format], one file per note, with the [subject].
///
/// The files are created by the share plugin in the temporary directory of the app, never in the shared storage.
Future<void> _shareFiles(List<Note> notes, NoteFormat format, {required String subject}) async {
  final mimeType = format.mimeType;

  // Make the file names unique, as several notes can have the same title and creation time
  final names = <String>[];
  for (final note in notes) {
    final baseName = note.fileNameWithoutExtension.isEmpty ? 'note' : note.fileNameWithoutExtension;
    var name = '$baseName.${mimeType.extension}';
    var index = 2;
    while (names.contains(name)) {
      name = '$baseName ($index).${mimeType.extension}';
      index++;
    }
    names.add(name);
  }

  final files = [
    for (final (index, note) in notes.indexed)
      XFile.fromData(utf8.encode(format.format(note)), mimeType: mimeType.value, name: names[index]),
  ];

  await SharePlus.instance.share(ShareParams(files: files, fileNameOverrides: names, subject: subject));
}
