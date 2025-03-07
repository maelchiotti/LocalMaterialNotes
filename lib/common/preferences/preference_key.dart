import 'preferences_wrapper.dart';

// ignore_for_file: public_member_api_docs

/// Keys of preferences.
enum PreferenceKey<T extends Object> {
  // Appearance
  locale<String>('en', backup: false),
  theme<String>('system'),
  dynamicTheming<bool>(true),
  blackTheming<bool>(false),
  appFont<String>('systemDefault'),
  editorFont<String>('systemDefault'),

  // Notes types
  availableNotesTypes<List<String>>(['plainText', 'richText', 'markdown', 'checklist']),
  defaultShareNoteType<String>('plainText'),

  // Rich text notes
  useParagraphsSpacing<bool>(true),

  // Notes tiles
  showTilesBackground<bool>(false),
  showSeparators<bool>(false),
  showTitlesOnly<bool>(false),
  showTitlesOnlyDisableInSearchView<bool>(true),
  maximumContentPreviewLines<int>(3),
  showNoteTypeIcon<bool>(true),

  // Behavior
  confirmations<String>('irreversible'),
  autoEmptyBin<int>(99999),
  swipeRightAction<String>('delete'),
  swipeLeftAction<String>('archive'),
  archivedSwipeRightAction<String>('delete'),
  archivedSwipeLeftAction<String>('unarchive'),
  binSwipeRightAction<String>('permanentlyDelete'),
  binSwipeLeftAction<String>('restore'),

  // Editor
  editorModeButton<bool>(true),
  openEditorReadingMode<bool>(false),
  focusTitleOnNewNote<bool>(false),

  // Labels
  enableLabels<bool>(true),
  showLabelsListOnNoteTile<bool>(true),
  showLabelsListInEditorPage<bool>(true),
  labelSwipeRightAction<String>('delete'),
  labelSwipeLeftAction<String>('edit'),

  // Backup
  enableAutoExport<bool>(true),
  autoExportFrequency<int>(3),
  autoExportEncryption<bool>(false, backup: false),
  autoExportPassword<String>('', secure: true, backup: false),
  autoExportDirectory<String>('', backup: false),
  lastAutoExportDate<String>('', backup: false),

  // Security
  flagSecure<bool>(false),
  lockApp<bool>(false, backup: false),
  lockAppDelay<int>(10),
  lockNote<bool>(false, backup: false),
  lockLabel<bool>(false, backup: false),
  lockNoteDelay<int>(10),

  // Accessibility
  textScaling<double>(1.0),
  biggerTitles(false),
  useWhiteTextDarkMode<bool>(false),
  disableSubduedNoteContentPreview<bool>(false),

  // Notes
  sortMethod<String>('editedDate', backup: false),
  sortAscending<bool>(false, backup: false),
  layout<String>('list', backup: false),

  // Database
  databaseVersion<int>(3, backup: false);

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
    await PreferencesWrapper().set<T>(this, value);
  }

  /// Resets this preference to its [defaultValue].
  Future<void> reset() async {
    await PreferencesWrapper().set<T>(this, defaultValue);
  }

  /// Returns the value of this preference if set, or [null] otherwise.
  T? get preference => PreferencesWrapper().get<T>(this);

  /// Returns the value of this preference if set, or its default value otherwise.
  T get preferenceOrDefault => PreferencesWrapper().get<T>(this) ?? defaultValue;

  /// Returns the value of this securely stored preference if set, or [null] otherwise.
  T? get preferenceSecure => PreferencesWrapper().get<T>(this);

  /// Returns the value of this securely stored preference if set, or its default value otherwise.
  Future<String> get preferenceOrDefaultSecure async =>
      await PreferencesWrapper().getSecure(this) ?? defaultValue as String;

  /// Removes the value of this preference.
  Future<void> remove() async {
    await PreferencesWrapper().remove(this);
  }
}
