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
Future<void> addNote<NoteType>(BuildContext context, WidgetRef ref, {String? content}) async {
  if (isNotesSelectionModeNotifier.value) {
    exitNotesSelectionMode(context, ref);
  }

  final Note note;
  switch (NoteType) {
    case == PlainTextNote:
      note = content == null ? PlainTextNote.empty() : PlainTextNote.content(content);
    case == RichTextNote:
      note = content == null ? RichTextNote.empty() : RichTextNote.content(content);
    case == ChecklistNote:
      note = ChecklistNote.empty();
    default:
      throw Exception('Unknown note type when creating a new note: $NoteType');
  }

  // If some content was provided, then immediately save the note without waiting for changes in the editor
  if (content != null) {
    ref.read(notesProvider(label: currentLabelFilter).notifier).edit(note);
  }

  currentNoteNotifier.value = note;

  NavigatorUtils.pushNotesEditor(context, false, true);
}
