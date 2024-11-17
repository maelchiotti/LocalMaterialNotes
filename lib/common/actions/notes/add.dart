import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/notes/select.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/notes/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';

/// Adds a note.
///
/// A [content] can be specified when the note is created from a sharing intent.
Future<void> addNote(BuildContext context, WidgetRef ref, {String? content}) async {
  if (isNotesSelectionModeNotifier.value) {
    exitNotesSelectionMode(context, ref);
  }

  final note = content == null ? Note.empty() : Note.content(content);

  // If some content was provided, immediately save the note without waiting for changes in the editor
  if (content != null) {
    ref.read(notesProvider.notifier).edit(note);
  }

  currentNoteNotifier.value = note;

  NotesEditorRoute(readOnly: false, autoFocus: true).push(context);
}
