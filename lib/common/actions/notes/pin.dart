import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/notes/select.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';

/// Toggles the pined status of the [note].
///
/// Returns `true` if the pined status of the [note] was toggled, `false` otherwise.
Future<bool> togglePinNote(BuildContext context, WidgetRef ref, Note? note) async {
  if (note == null) {
    return false;
  }

  await ref.read(notesProvider.notifier).togglePin(note);

  return false;
}

/// Toggles the pined status of the [notes].
Future<void> togglePinNotes(BuildContext context, WidgetRef ref, List<Note> notes) async {
  await ref.read(notesProvider.notifier).togglePinAll(notes);

  if (context.mounted) {
    exitNotesSelectionMode(context, ref);
  }
}
