import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../preferences/preference_key.dart';
import 'select.dart';

/// Toggles the locked status of the [notes].
Future<bool> toggleLockNotes(
  BuildContext context,
  WidgetRef ref, {
  required List<Note> notes,
  bool requireAuthentication = false,
}) async {
  if (requireAuthentication) {
    final lockNotePreference = PreferenceKey.lockNote.preferenceOrDefault;
    final wasLocked = notes.first.locked;

    // If the lock note setting is enabled and the note was locked, then ask to authenticate before unlocking the note
    if (lockNotePreference && wasLocked) {
      final bool authenticated = await LocalAuthentication().authenticate(localizedReason: 'toggle');

      if (!authenticated) {
        return false;
      }
    }
  }

  final toggled = await ref
      .read(
        notesProvider(
          status: NoteStatus.available,
          label: currentLabelFilter,
        ).notifier,
      )
      .toggleLock(notes);

  if (context.mounted && notes.length > 1) {
    exitNotesSelectionMode(context, ref, notesStatus: NoteStatus.available);
  }

  return toggled;
}
