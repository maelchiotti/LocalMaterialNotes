import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';

Future<bool> togglePinNote(BuildContext context, WidgetRef ref, Note? note) async {
  if (note == null) return false;

  await ref.read(notesProvider.notifier).togglePin(note);

  return false;
}

Future<void> togglePinNotes(BuildContext context, WidgetRef ref, List<Note> notes) async {
  for (final note in notes) {
    await ref.read(notesProvider.notifier).togglePin(note);
  }
}
