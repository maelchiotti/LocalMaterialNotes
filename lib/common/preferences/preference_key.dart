import 'preferences_utils.dart';

// ignore_for_file: public_member_api_docs

/// Keys of preferences.
enum PreferenceKey<T> {
  // Appearance
  locale<String>('en', backup: false),
  theme<String>('system'),
  dynamicTheming<bool>(true),
  blackTheming<bool>(false),
  appFont<String>('systemDefault'),
  showTilesBackground<bool>(false),
  showSeparators<bool>(false),
  showTitlesOnly<bool>(false),
  showTitlesOnlyDisableInSearchView<bool>(true),

  // Behavior
  flagSecure<bool>(false),
  confirmations<String>('irreversible'),
  swipeRightAction<String>('delete'),
  swipeLeftAction<String>('togglePin'),

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
  autoExportEncryption<bool>(false, backup: false),
  autoExportPassword<String>('', secure: true, backup: false),
  autoExportDirectory<String>('', backup: false),
  lastAutoExportDate<String>('', backup: false),

  // Accessibility
  textScaling<double>(1.0),
  biggerTitles(false),
  useWhiteTextDarkMode<bool>(false),
  disableSubduedNoteContentPreview<bool>(false),

  // Notes
  sortMethod<String>('editedDate', backup: false),
  sortAscending<bool>(false, backup: false),
  layout<String>('list', backup: false),
  ;

  /// Default value of this preference.
  final T defaultValue;

  /// Whether this preference should be securely stored.
  ///
  /// Defaults to `false`.
  final bool secure;

  /// Whether this preference can be included in backups.
  ///
  /// Defaults to `true`.
  final bool backup;

  /// The key of a preference.
  ///
  /// Every preference has a [defaultValue] and a type [T].
  ///
  /// If the preference should be securely stored, it can be marked as [secure].
  const PreferenceKey(this.defaultValue, {this.secure = false, this.backup = true});

  /// Sets this preference to the [value] with the type [T].
  Future<void> set(T value) async {
    await PreferencesUtils().set<T>(this, value);
  }

  /// Resets this preference to its [defaultValue].
  Future<void> reset() async {
    await PreferencesUtils().set<T>(this, defaultValue);
  }

  /// Returns the value of this preference if set, or [null] otherwise.
  T? getPreference() => PreferencesUtils().get<T>(this);

  /// Returns the value of this preference if set, or its default value otherwise.
  T getPreferenceOrDefault() => PreferencesUtils().get<T>(this) ?? defaultValue;

  /// Returns the value of this securely stored preference if set, or [null] otherwise.
  T? getPreferenceSecure() => PreferencesUtils().get<T>(this);

  /// Returns the value of this securely stored preference if set, or its default value otherwise.
  Future<String> getPreferenceOrDefaultSecure() async =>
      await PreferencesUtils().getSecure(this) ?? defaultValue as String;

  /// Removes the value of this preference.
  Future<void> remove() async {
    await PreferencesUtils().remove(this);
  }
}
