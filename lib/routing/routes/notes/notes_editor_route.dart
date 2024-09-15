import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/pages/editor/editor_page.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Route of the notes editor page.
@immutable
class NotesEditorRoute extends GoRouteData {
  /// Default constructor.
  const NotesEditorRoute({
    required this.readOnly,
    required this.autoFocus,
  });

  /// Whether the text fields should be read only.
  final bool readOnly;

  /// Whether to automatically focus the content text field.
  final bool autoFocus;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    isFleatherEditorEditMode.value = !PreferenceKey.openEditorReadingMode.getPreferenceOrDefault<bool>();

    return NoTransitionPage(
      child: NotesEditorPage(
        key: Keys.pageNotes,
        readOnly: readOnly,
        isNewNote: autoFocus,
      ),
    );
  }
}
