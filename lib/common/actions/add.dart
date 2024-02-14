import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/routing/editor_parameters.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/current_note/current_note_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';

Future<void> addNote(BuildContext context, WidgetRef ref, {String? content}) async {
  final note = content == null ? Note.empty() : Note.content(content);

  ref.read(currentNoteProvider.notifier).set(note);
  await ref.read(notesProvider.notifier).add(note);

  if (context.mounted) {
    final route = RouterRoute.editor.fullPath!;

    // If the editor is already opened with another note, replace the route with the new editor
    RouterRoute.isEditor
        ? context.pushReplacement(route, extra: editorParametersNewNote)
        : context.push(route, extra: editorParametersNewNote);
  }
}
