import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/navigation/navigation_routes.dart';
import 'package:localmaterialnotes/pages/editor/editor_page.dart';
import 'package:localmaterialnotes/providers/notifiers/notifiers.dart';

/// Utilities for the navigation.
class NavigatorUtils {
  /// Goes to a new route with a [name] and a [page].
  static void go(BuildContext context, String name, Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => page,
        settings: RouteSettings(name: name),
      ),
    );
  }

  /// Pushes a new route with a [name] and a [page].
  static void push(BuildContext context, String name, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => page,
        settings: RouteSettings(name: name),
      ),
    );
  }

  /// Pushes the notes editor route with its parameters [readOnly] and a [isNewNote].
  static void pushNotesEditor(BuildContext context, bool readOnly, bool isNewNote) {
    isFleatherEditorEditMode.value = !PreferenceKey.openEditorReadingMode.getPreferenceOrDefault();

    push(
      context,
      NavigationRoute.notesEditor.name,
      NotesEditorPage(readOnly: readOnly, isNewNote: isNewNote),
    );
  }

  /// Pops all pages until the home page is reached.
  static void popToHome(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }
}
