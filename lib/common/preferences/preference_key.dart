import 'package:localmaterialnotes/common/preferences/enums/confirmations.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/preferences/enums/sort_method.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';

// ignore_for_file: public_member_api_docs

/// Lists the preferences' keys.
enum PreferenceKey<T> {
  // Appearance
  locale<String>('en'),
  theme<int>(0),
  dynamicTheming<bool>(true),
  blackTheming<bool>(false),
  showTitlesOnly<bool>(false),
  showTitlesOnlyDisableInSearchView<bool>(true),
  disableSubduedNoteContentPreview<bool>(false),
  showSeparators<bool>(false),
  showTilesBackground<bool>(false),

  // Behavior
  flagSecure<bool>(false),
  confirmations<String>(Confirmations.irreversible),
  swipeRightAction<String>(SwipeAction.delete),
  swipeLeftAction<String>(SwipeAction.togglePin),

  // Editor
  showUndoRedoButtons<bool>(true),
  showChecklistButton<bool>(true),
  showToolbar<bool>(true),
  editorModeButton<bool>(true),
  openEditorReadingMode<bool>(false),
  focusTitleOnNewNote<bool>(false),
  useParagraphsSpacing<bool>(true),

  // Labels
  enableLabels<bool>(true),
  showLabelsListOnNoteTile<bool>(true),
  showLabelsListInEditorPage<bool>(true),

  // Backup
  enableAutoExport<bool>(false),
  autoExportFrequency<int>(1),
  autoExportEncryption<bool>(false),
  autoExportPassword<String>('', secure: true),
  autoExportDirectory<String>(''),
  lastAutoExportDate<String>(''),

  // Accessibility
  textScaling<double>(1.0),
  useWhiteTextDarkMode<bool>(false),

  // Notes
  sortMethod<String>(SortMethod.editedDate),
  sortAscending<bool>(false),
  layout<String>(Layout.list),
  ;

  /// Default value of the preference.
  final Object defaultValue;

  /// Whether the preference should be securely stored.
  final bool secure;

  /// The key of a preference.
  ///
  /// Every preference has a [defaultValue] and a type [T].
  ///
  /// If the preference should be securely stored, it can be marked as [secure].
  const PreferenceKey(this.defaultValue, {this.secure = false});

  /// Sets the preference to the [value] with the type [T].
  Future<void> set(T value) async {
    await PreferencesUtils().set<T>(this, value);
  }

  /// Resets the preference to its [defaultValue].
  Future<void> setToDefault() async {
    await PreferencesUtils().set(this, defaultValue);
  }

  /// Returns the value of the preference if set, or [null] otherwise.
  T? getPreference() {
    return PreferencesUtils().get<T>(this);
  }

  /// Returns the value of the preference if set, or its default value otherwise.
  T getPreferenceOrDefault() {
    return PreferencesUtils().get<T>(this) ?? defaultValue as T;
  }

  /// Returns the value of the securely stored preference if set, or [null] otherwise.
  T? getPreferenceSecure() {
    return PreferencesUtils().get<T>(this);
  }

  /// Returns the value of the securely stored preference if set, or its default value otherwise.
  Future<String> getPreferenceOrDefaultSecure() async {
    return await PreferencesUtils().getSecure(this) ?? defaultValue as String;
  }

  Future<void> remove() async {
    await PreferencesUtils().remove(this);
  }
}
