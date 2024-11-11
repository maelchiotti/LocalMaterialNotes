import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/pages/notes/notes_page.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Route of the notes page.
@immutable
class NotesRoute extends GoRouteData {
  /// Route of the notes list page.
  ///
  /// The label to filter the notes can be passed to [$extra]. In this case, the name of the label
  /// should also be passed to [labelName] so it can be displayed in the app bar.
  const NotesRoute({this.labelName, this.$extra});

  /// The name of the label used to filter the notes.
  ///
  /// It is used so it can be displayed in the app bar.
  final String? labelName;

  /// The label used to filter the notes.
  final Label? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NotesPage(
      key: Keys.pageNotes,
      label: $extra,
    );
  }
}
