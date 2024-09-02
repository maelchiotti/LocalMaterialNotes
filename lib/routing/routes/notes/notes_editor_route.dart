import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/editor/editor_page.dart';

@immutable
class NotesEditorRoute extends GoRouteData {
  const NotesEditorRoute({
    required this.readOnly,
    required this.autoFocus,
  });

  final bool readOnly;
  final bool autoFocus;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return NoTransitionPage(
      child: NotesEditorPage(
        readOnly: readOnly,
        autofocus: autoFocus,
      ),
    );
  }
}
