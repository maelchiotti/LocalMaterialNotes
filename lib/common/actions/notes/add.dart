import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parchment_delta/parchment_delta.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../models/note/types/note_type.dart';
import '../../../navigation/navigation_routes.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../types.dart';
import 'select.dart';

/// Adds a note.
///
/// A [content] can be specified when the note is created from a sharing intent.
Future<void> addNote(BuildContext context, WidgetRef ref, {required NoteType noteType, String? content}) async {
  if (isNotesSelectionModeNotifier.value) {
    exitNotesSelectionMode(context, ref, notesStatus: NoteStatus.available);
  }

  final Note note;
  switch (noteType) {
    case NoteType.plainText:
      note = content == null ? PlainTextNote.empty() : PlainTextNote.content(content);
    case NoteType.markdown:
      note = content == null ? MarkdownNote.empty() : MarkdownNote.content(content);
    case NoteType.richText:
      if (content != null) {
        final delta = Delta();
        for (final line in content.split('\n')) {
          delta.insert('$line\n');
        }

        note = RichTextNote.content(jsonEncode(delta));
      } else {
        note = RichTextNote.empty();
      }

    case NoteType.checklist:
      note = ChecklistNote.empty();
  }

  // If some content was provided, then immediately save the note without waiting for changes in the editor
  if (content != null) {
    await ref.read(notesProvider(status: NoteStatus.available, label: currentLabelFilter).notifier).edit(note);
  }

  currentNoteNotifier.value = note;

  if (!context.mounted) {
    return;
  }

  final EditorPageExtra extra = (readOnly: false, isNewNote: true);

  await context.pushNamed(NavigationRoute.editor.name, extra: extra);
}
