import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../navigation/navigator_utils.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import 'select.dart';

/// Adds a note.
///
/// A [content] can be specified when the note is created from a sharing intent.
Future<void> addNote(BuildContext context, WidgetRef ref, {String? content}) async {
  if (isNotesSelectionModeNotifier.value) {
    exitNotesSelectionMode(context, ref);
  }

  final note = content == null ? RichTextNote.empty() : RichTextNote.content(content);

  // If some content was provided, immediately save the note without waiting for changes in the editor
  if (content != null) {
    ref.read(notesProvider.notifier).edit(note);
  }

  currentNoteNotifier.value = note;

  NavigatorUtils.pushNotesEditor(context, false, true);
}
