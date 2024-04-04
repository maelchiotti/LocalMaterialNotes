import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/actions/select.dart';
import 'package:localmaterialnotes/common/routing/router.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/current_note/current_note_provider.dart';

Future<void> addNote(BuildContext context, WidgetRef ref, {String? content}) async {
  exitSelectionMode(ref);
  print("1");
  final note = content == null ? Note.empty() : Note.content(content);
  print("2");
  ref.read(currentNoteProvider.notifier).set(note);
  print("3");
  if (!context.mounted) return;
  print("4");
  final editorRoute = RouterRoute.editor.fullPath!;
  final editorParameters = EditorParameters.from({'readonly': false, 'autofocus': true});
  print("5");
  // If the editor is already opened with another note, replace the route with the new editor
  RouterRoute.isEditor
      ? context.pushReplacement(editorRoute, extra: editorParameters)
      : context.push(editorRoute, extra: editorParameters);
}
