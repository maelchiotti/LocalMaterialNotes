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

  // Labels
  enableLabels(true),
  showLabelsListOnNoteTile(true),
  showLabelsListInEditorPage(true),

  // Backup
  enableAutoExport(false),
  autoExportFrequency(1),
  autoExportEncryption(false),
  autoExportPassword('', secure: true),
  autoExportDirectory(''),
  lastAutoExportDate(''),

  // Accessibility
  textScaling(1.0),
  useWhiteTextDarkMode(false),

  // Notes
  sortMethod(SortMethod.editedDate),
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

  /// Sets the preference to the [value] with the type [T].
  Future<void> set<T>(T value) async {
    await PreferencesUtils().set<T>(this, value);
  }

  /// Resets the preference to its [defaultValue].
  Future<void> setToDefault() async {
    await PreferencesUtils().set(this, defaultValue);
  }

  /// Returns the value of the preference if set, or its default value otherwise.
  T? getPreference<T>() {
    return PreferencesUtils().get<T>(this);
  }

  /// Returns the value of the preference if set, or its default value otherwise.
  T getPreferenceOrDefault<T>() {
    return PreferencesUtils().get<T>(this) ?? defaultValue as T;
  }

  /// Returns the value of the securely stored preference if set, or its default value otherwise.
  Future<String> getPreferenceOrDefaultSecure() async {
    return await PreferencesUtils().getSecure(this) ?? defaultValue as String;
  }

  Future<void> remove() async {
    await PreferencesUtils().remove(this);
  }
}
