import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/pages/notes/notes_page.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Route of the notes page.
@immutable
class NotesRoute extends GoRouteData {
  const NotesRoute({this.labelName, this.$extra});

  final String? labelName;

  final Label? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NotesPage(
      key: Keys.pageNotes,
      label: $extra,
    );
  }
}
