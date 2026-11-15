import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../authentication.dart';
import 'select.dart';

/// Toggles whether the [notes] are locked.
Future<bool> toggleLockNotes(BuildContext context, WidgetRef ref, {required List<Note> notes}) async {
  if (!await authenticateIfRequired(context, notes)) {
    return false;
  }

  final toggled = await ref
      .read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier)
      .toggleLock(notes);

  if (context.mounted && notes.length > 1) {
    exitNotesSelectionMode(context, ref, notesStatus: NoteStatus.available);
  }

  return toggled;
}
