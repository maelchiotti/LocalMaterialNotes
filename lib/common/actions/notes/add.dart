import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../models/note/types/note_type.dart';
import '../../../navigation/navigator_utils.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import 'select.dart';

/// Adds a note.
///
/// A [content] can be specified when the note is created from a sharing intent.
Future<void> addNote(BuildContext context, WidgetRef ref, {required NoteType noteType, String? content}) async {
  if (isNotesSelectionModeNotifier.value) {
    exitNotesSelectionMode(context, ref);
  }

  final Note note;
  switch (noteType) {
    case NoteType.plainText:
      note = content == null ? PlainTextNote.empty() : PlainTextNote.content(content);
    case NoteType.markdown:
      note = content == null ? MarkdownNote.empty() : MarkdownNote.content(content);
    case NoteType.richText:
      note = content == null ? RichTextNote.empty() : RichTextNote.content(content);
    case NoteType.checklist:
      note = ChecklistNote.empty();
  }

  // If some content was provided, then immediately save the note without waiting for changes in the editor
  if (content != null) {
    ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).edit(note);
  }

  currentNoteNotifier.value = note;

  NavigatorUtils.pushNotesEditor(context, false, true);
}
