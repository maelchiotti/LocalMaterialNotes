import 'dart:developer';

import 'package:localmaterialnotes/common/preferences/enums/confirmations.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/preferences/enums/sort_method.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';

// ignore_for_file: public_member_api_docs

/// Lists the preferences' keys.
enum PreferenceKey {
  // Appearance
  locale('en'),
  theme(0),
  dynamicTheming(true),
  blackTheming(false),
  textScaling(1.0),
  showTitlesOnly(false),
  showTitlesOnlyDisableInSearchView(true),
  disableSubduedNoteContentPreview(false),
  showSeparators(false),
  showTilesBackground(false),

  // Behavior
  flagSecure(false),
  confirmations(Confirmations.irreversible),
  swipeRightAction(SwipeAction.delete),
  swipeLeftAction(SwipeAction.togglePin),

  // Editor
  showUndoRedoButtons(true),
  showChecklistButton(true),
  showToolbar(true),
  editorModeButton(true),
  openEditorReadingMode(false),
  focusTitleOnNewNote(false),
  useParagraphsSpacing(true),

  // Backup
  enableAutoExport(false),
  autoExportFrequency(1),
  autoExportEncryption(false),
  autoExportPassword('', secure: true),
  autoExportDirectory(''),
  lastAutoExportDate(''),

  // Notes
  sortMethod(SortMethod.date),
  sortAscending(false),
  layout(Layout.list),
  ;

  /// Default value of the preference.
  final Object defaultValue;

  /// Whether the preference should be securely stored.
  final bool secure;

  /// The key of a preference.
  ///
  /// Every preference has a [defaultValue].
  ///
  /// if the preference should be securely stored, it can be marked as [secure].
  const PreferenceKey(this.defaultValue, {this.secure = false});

  /// Returns the value of the preference if set, or its default value otherwise.
  ///
  /// The type [T] of the value should be a basic type: `bool`, `int`, `double`, `String` or `List<String>`.
  T getPreferenceOrDefault<T>() {
    if (T == dynamic) {
      throw ArgumentError('The type T is required.');
    }

    if (T != bool && T != int && T != double && T != String && T != List<String>) {
      throw ArgumentError('The type T should be a native type (bool, int, double, String or List<String>), not $T.');
    }

    try {
      return PreferencesUtils().get<T>(this) ?? defaultValue as T;
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);

      return defaultValue as T;
    }
  }

  /// Returns the value of the securely stored preference if set, or its default value otherwise.
  Future<String> getPreferenceOrDefaultSecure() async {
    return await PreferencesUtils().getSecure(this) ?? defaultValue as String;
  }
}
