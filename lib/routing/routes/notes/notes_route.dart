import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/notes/notes_page.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Route of the notes page.
@immutable
class NotesRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NotesPage(
      key: Keys.pageNotes,
    );
  }
}
