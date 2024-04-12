import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.g.dart';
import 'app_localizations_fr.g.dart';
import 'app_localizations_tr.g.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.g.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en'), Locale('fr'), Locale('tr')];

  /// No description provided for @app_name.
  ///
  /// In en, this message translates to:
  /// **'Material Notes'**
  String get app_name;

  /// No description provided for @app_tagline.
  ///
  /// In en, this message translates to:
  /// **'Simple, local, material design notes'**
  String get app_tagline;

  /// No description provided for @app_about.
  ///
  /// In en, this message translates to:
  /// **'{appName} is a text-based note-taking application, aimed at simplicity. It embraces Material Design. It stores the notes locally and doesn\'\'t have any internet permissions, so you are the only one that can access the notes.'**
  String app_about(Object appName);

  /// No description provided for @navigation_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get navigation_notes;

  /// No description provided for @navigation_bin.
  ///
  /// In en, this message translates to:
  /// **'Bin'**
  String get navigation_bin;

  /// No description provided for @navigation_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navigation_settings;

  /// No description provided for @error_error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_error;

  /// No description provided for @error_permission.
  ///
  /// In en, this message translates to:
  /// **'Failed to get permission to write the file.'**
  String get error_permission;

  /// No description provided for @error_read_file.
  ///
  /// In en, this message translates to:
  /// **'Failed to read the file.'**
  String get error_read_file;

  /// No description provided for @settings_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_appearance;

  /// No description provided for @settings_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_theme;

  /// No description provided for @settings_theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_theme_system;

  /// No description provided for @settings_theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_theme_light;

  /// No description provided for @settings_theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_theme_dark;

  /// No description provided for @settings_dynamic_theming.
  ///
  /// In en, this message translates to:
  /// **'Dynamic theming'**
  String get settings_dynamic_theming;

  /// No description provided for @settings_dynamic_theming_description.
  ///
  /// In en, this message translates to:
  /// **'Generate colors from your system'**
  String get settings_dynamic_theming_description;

  /// No description provided for @settings_black_theming.
  ///
  /// In en, this message translates to:
  /// **'Black theming'**
  String get settings_black_theming;

  /// No description provided for @settings_black_theming_description.
  ///
  /// In en, this message translates to:
  /// **'Use a black background in dark mode'**
  String get settings_black_theming_description;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_separator.
  ///
  /// In en, this message translates to:
  /// **'Show the separators'**
  String get settings_separator;

  /// No description provided for @settings_separator_description.
  ///
  /// In en, this message translates to:
  /// **'Show a separator between notes to differentiate them easily'**
  String get settings_separator_description;

  /// No description provided for @settings_behavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get settings_behavior;

  /// No description provided for @settings_confirmations.
  ///
  /// In en, this message translates to:
  /// **'Show confirmation dialogs'**
  String get settings_confirmations;

  /// No description provided for @settings_backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settings_backup;

  /// No description provided for @settings_export_json.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get settings_export_json;

  /// No description provided for @settings_export_markdown.
  ///
  /// In en, this message translates to:
  /// **'Export as Markdown'**
  String get settings_export_markdown;

  /// No description provided for @settings_export_json_description.
  ///
  /// In en, this message translates to:
  /// **'Export notes to a JSON file (bin included) that can be imported back'**
  String get settings_export_json_description;

  /// No description provided for @settings_export_markdown_description.
  ///
  /// In en, this message translates to:
  /// **'Export notes to a Markdown file (bin included)'**
  String get settings_export_markdown_description;

  /// No description provided for @settings_export_success.
  ///
  /// In en, this message translates to:
  /// **'The notes were successfully exported.'**
  String get settings_export_success;

  /// No description provided for @settings_import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get settings_import;

  /// No description provided for @settings_import_description.
  ///
  /// In en, this message translates to:
  /// **'Import notes from a JSON file'**
  String get settings_import_description;

  /// No description provided for @settings_import_success.
  ///
  /// In en, this message translates to:
  /// **'The notes were successfully imported.'**
  String get settings_import_success;

  /// No description provided for @settings_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_about;

  /// No description provided for @settings_github.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get settings_github;

  /// No description provided for @settings_github_description.
  ///
  /// In en, this message translates to:
  /// **'Take a look at the source code'**
  String get settings_github_description;

  /// No description provided for @settings_licence.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get settings_licence;

  /// No description provided for @settings_licence_description.
  ///
  /// In en, this message translates to:
  /// **'AGPL-3.0'**
  String get settings_licence_description;

  /// No description provided for @settings_issue.
  ///
  /// In en, this message translates to:
  /// **'Report a bug'**
  String get settings_issue;

  /// No description provided for @settings_issue_description.
  ///
  /// In en, this message translates to:
  /// **'Report a bug by creating an issue on GitHub'**
  String get settings_issue_description;

  /// No description provided for @hint_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get hint_title;

  /// No description provided for @hint_note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get hint_note;

  /// No description provided for @tooltip_fab_add_note.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get tooltip_fab_add_note;

  /// No description provided for @tooltip_fab_empty_bin.
  ///
  /// In en, this message translates to:
  /// **'Empty the bin'**
  String get tooltip_fab_empty_bin;

  /// No description provided for @tooltip_sort.
  ///
  /// In en, this message translates to:
  /// **'Sort the notes'**
  String get tooltip_sort;

  /// No description provided for @tooltip_search.
  ///
  /// In en, this message translates to:
  /// **'Search the notes'**
  String get tooltip_search;

  /// No description provided for @tooltip_toggle_checkbox.
  ///
  /// In en, this message translates to:
  /// **'Toggle checkbox'**
  String get tooltip_toggle_checkbox;

  /// No description provided for @tooltip_select_all.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get tooltip_select_all;

  /// No description provided for @tooltip_unselect_all.
  ///
  /// In en, this message translates to:
  /// **'Unselect all'**
  String get tooltip_unselect_all;

  /// No description provided for @tooltip_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get tooltip_delete;

  /// No description provided for @tooltip_permanently_delete.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete'**
  String get tooltip_permanently_delete;

  /// No description provided for @tooltip_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get tooltip_restore;

  /// No description provided for @tooltip_toggle_pins.
  ///
  /// In en, this message translates to:
  /// **'Toggle pins'**
  String get tooltip_toggle_pins;

  /// No description provided for @button_ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get button_ok;

  /// No description provided for @button_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get button_close;

  /// No description provided for @button_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get button_cancel;

  /// No description provided for @button_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get button_add;

  /// No description provided for @dialog_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialog_delete;

  /// No description provided for @dialog_delete_body.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete {count} {count, plural, zero{} one{note} other{notes}}? You can restore {count, plural, zero{} one{it} other{them}} from the bin.'**
  String dialog_delete_body(num count);

  /// No description provided for @dialog_delete_body_single.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete this note? You can restore it from the bin.'**
  String get dialog_delete_body_single;

  /// No description provided for @dialog_permanently_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get dialog_permanently_delete;

  /// No description provided for @dialog_permanently_delete_body.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to permanently delete {count} {count, plural, zero{} one{note} other{notes}}? You will not be able to restore {count, plural, zero{} one{it} other{them}}.'**
  String dialog_permanently_delete_body(num count);

  /// No description provided for @dialog_permanently_delete_body_single.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to permanently delete this note? You will not be able to restore it.'**
  String get dialog_permanently_delete_body_single;

  /// No description provided for @dialog_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get dialog_restore;

  /// No description provided for @dialog_restore_body.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to restore {count} {count, plural, zero{} one{note} other{notes}}?'**
  String dialog_restore_body(num count);

  /// No description provided for @dialog_restore_body_single.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to restore this note?'**
  String get dialog_restore_body_single;

  /// No description provided for @dialog_empty_bin.
  ///
  /// In en, this message translates to:
  /// **'Empty the bin'**
  String get dialog_empty_bin;

  /// No description provided for @dialog_empty_bin_body.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to permanently empty the bin? You will not be able to restore the notes it contains.'**
  String get dialog_empty_bin_body;

  /// No description provided for @sort_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sort_date;

  /// No description provided for @sort_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get sort_title;

  /// No description provided for @sort_ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get sort_ascending;

  /// No description provided for @placeholder_notes.
  ///
  /// In en, this message translates to:
  /// **'No notes'**
  String get placeholder_notes;

  /// No description provided for @placeholder_bin.
  ///
  /// In en, this message translates to:
  /// **'The bin is empty'**
  String get placeholder_bin;

  /// No description provided for @menu_pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get menu_pin;

  /// No description provided for @menu_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get menu_share;

  /// No description provided for @menu_unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get menu_unpin;

  /// No description provided for @menu_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get menu_delete;

  /// No description provided for @menu_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get menu_restore;

  /// No description provided for @menu_delete_permanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get menu_delete_permanently;

  /// No description provided for @menu_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menu_about;

  /// No description provided for @notes_untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled note'**
  String get notes_untitled;

  /// No description provided for @confirmations_title_none.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get confirmations_title_none;

  /// No description provided for @confirmations_title_irreversible.
  ///
  /// In en, this message translates to:
  /// **'Irreversible actions only'**
  String get confirmations_title_irreversible;

  /// No description provided for @confirmations_title_all.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get confirmations_title_all;

  /// No description provided for @dismiss_pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get dismiss_pin;

  /// No description provided for @dismiss_unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get dismiss_unpin;

  /// No description provided for @dismiss_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dismiss_delete;

  /// No description provided for @dismiss_permanently_delete.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete'**
  String get dismiss_permanently_delete;

  /// No description provided for @dismiss_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get dismiss_restore;

  /// No description provided for @about_last_edited.
  ///
  /// In en, this message translates to:
  /// **'Last edited'**
  String get about_last_edited;

  /// No description provided for @about_created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get about_created;

  /// No description provided for @about_words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get about_words;

  /// No description provided for @about_characters.
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get about_characters;

  /// No description provided for @time_at.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get time_at;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
