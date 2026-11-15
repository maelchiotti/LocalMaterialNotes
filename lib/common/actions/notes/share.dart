import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_format.dart';
import '../../extensions/build_context_extension.dart';
import '../authentication.dart';

/// Shares the [note] as text (title and content).
///
/// Asks for authentication if the [note] requires it, unless the user [alreadyAuthenticated] (in the editor).
Future<void> shareNote(BuildContext context, {required Note note, bool alreadyAuthenticated = false}) async {
  if (!alreadyAuthenticated && !await authenticateIfRequired(context, [note])) {
    return;
  }

  await SharePlus.instance.share(ShareParams(text: NoteFormat.text.format(note), subject: note.title));
}

/// Shares the [notes] as text (title and content), separated by dashes.
///
/// Asks for authentication if any of the [notes] requires it.
Future<void> shareNotes(BuildContext context, {required List<Note> notes}) async {
  if (!await authenticateIfRequired(context, notes)) {
    return;
  }

  final text = NoteFormat.text.formatAll(notes);

  if (!context.mounted) {
    return;
  }

  await SharePlus.instance.share(ShareParams(text: text, subject: context.l.action_share_subject(notes.length)));
}
