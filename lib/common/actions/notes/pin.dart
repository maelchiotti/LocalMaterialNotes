import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import 'select.dart';

/// Toggles whether the [notes] are pinned.
Future<bool> togglePinNotes(BuildContext context, WidgetRef ref, {required List<Note> notes}) async {
  final toggled = await ref
      .read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier)
      .togglePin(notes);

  if (context.mounted && notes.length > 1) {
    exitNotesSelectionMode(context, ref, notesStatus: NoteStatus.available);
  }

  return toggled;
}
