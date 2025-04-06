import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/note/note.dart';
import '../../extensions/build_context_extension.dart';

/// Shares the [note] as text (title and content).
Future<void> shareNote({required Note note}) async {
  await Share.share(note.shareText, subject: note.title);
}

/// Shares the [notes] as text (title and content), separated by dashes.
Future<void> shareNotes(BuildContext context, {required List<Note> notes}) async {
  final text = notes.map((note) => note.shareText).join('\n\n----------\n\n').trim();

  await Share.share(text, subject: context.l.action_share_subject(notes.length));
}
