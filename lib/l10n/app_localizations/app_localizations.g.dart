import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.g.dart';
import 'app_localizations_es.g.dart';
import 'app_localizations_fr.g.dart';
import 'app_localizations_pt.g.dart';
import 'app_localizations_ru.g.dart';
import 'app_localizations_tr.g.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'app_localizations/app_localizations.g.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr')
  ];

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

  /// No description provided for @navigation_settings_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get navigation_settings_appearance;

  /// No description provided for @navigation_settings_behavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get navigation_settings_behavior;

  /// No description provided for @navigation_settings_editor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get navigation_settings_editor;

  /// No description provided for @navigation_settings_backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get navigation_settings_backup;

  /// No description provided for @navigation_settings_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navigation_settings_about;

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

  /// No description provided for @settings_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_appearance;

  /// No description provided for @settings_appearance_description.
  ///
  /// In en, this message translates to:
  /// **'Language, theme, notes tiles'**
  String get settings_appearance_description;

  /// No description provided for @settings_appearance_application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get settings_appearance_application;

  /// No description provided for @settings_appearance_notes_tiles.
  ///
  /// In en, this message translates to:
  /// **'Notes tiles'**
  String get settings_appearance_notes_tiles;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

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
  /// **'Generate colors from the system'**
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

  /// No description provided for @settings_show_titles_only.
  ///
  /// In en, this message translates to:
  /// **'Titles only'**
  String get settings_show_titles_only;

  /// No description provided for @settings_show_titles_only_description.
  ///
  /// In en, this message translates to:
  /// **'Only show the titles of the notes so more of them can be displayed'**
  String get settings_show_titles_only_description;

  /// No description provided for @settings_show_tiles_background.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get settings_show_tiles_background;

  /// No description provided for @settings_show_tiles_background_description.
  ///
  /// In en, this message translates to:
  /// **'Show the background of the notes tiles to differentiate them easily'**
  String get settings_show_tiles_background_description;

  /// No description provided for @settings_show_separators.
  ///
  /// In en, this message translates to:
  /// **'Separators'**
  String get settings_show_separators;

  /// No description provided for @settings_show_separators_description.
  ///
  /// In en, this message translates to:
  /// **'Show a separator between the notes tiles to differentiate them easily'**
  String get settings_show_separators_description;

  /// No description provided for @settings_behavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get settings_behavior;

  /// No description provided for @settings_behavior_application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get settings_behavior_application;

  /// No description provided for @settings_behavior_description.
  ///
  /// In en, this message translates to:
  /// **'Confirmations, swipe actions'**
  String get settings_behavior_description;

  /// No description provided for @settings_behavior_swipe_actions.
  ///
  /// In en, this message translates to:
  /// **'Swipe actions'**
  String get settings_behavior_swipe_actions;

  /// No description provided for @settings_confirmations.
  ///
  /// In en, this message translates to:
  /// **'Confirmation dialogs'**
  String get settings_confirmations;

  /// No description provided for @settings_confirmations_description.
  ///
  /// In en, this message translates to:
  /// **'Show the confirmation dialogs for actions such as pining and deleting notes'**
  String get settings_confirmations_description;

  /// No description provided for @settings_swipe_action_right.
  ///
  /// In en, this message translates to:
  /// **'Right swipe action'**
  String get settings_swipe_action_right;

  /// No description provided for @settings_swipe_action_right_description.
  ///
  /// In en, this message translates to:
  /// **'Action to trigger when a right swipe is performed on the notes tiles'**
  String get settings_swipe_action_right_description;

  /// No description provided for @settings_swipe_action_left.
  ///
  /// In en, this message translates to:
  /// **'Left swipe action'**
  String get settings_swipe_action_left;

  /// No description provided for @settings_swipe_action_left_description.
  ///
  /// In en, this message translates to:
  /// **'Action to trigger when a left swipe is performed on the notes tiles'**
  String get settings_swipe_action_left_description;

  /// No description provided for @settings_flag_secure.
  ///
  /// In en, this message translates to:
  /// **'Flag the app as secure'**
  String get settings_flag_secure;

  /// No description provided for @settings_flag_secure_description.
  ///
  /// In en, this message translates to:
  /// **'Hide the app from the recent apps and prevent screenshots from being made'**
  String get settings_flag_secure_description;

  /// No description provided for @settings_editor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get settings_editor;

  /// No description provided for @settings_editor_formatting.
  ///
  /// In en, this message translates to:
  /// **'Formatting'**
  String get settings_editor_formatting;

  /// No description provided for @settings_editor_behavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get settings_editor_behavior;

  /// No description provided for @settings_editor_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_editor_appearance;

  /// No description provided for @settings_editor_description.
  ///
  /// In en, this message translates to:
  /// **'Buttons, toolbar, spacing'**
  String get settings_editor_description;

  /// No description provided for @settings_show_undo_redo_buttons.
  ///
  /// In en, this message translates to:
  /// **'Undo/redo buttons'**
  String get settings_show_undo_redo_buttons;

  /// No description provided for @settings_show_undo_redo_buttons_description.
  ///
  /// In en, this message translates to:
  /// **'Show the buttons to undo and redo changes in the editor\'\'s app bar'**
  String get settings_show_undo_redo_buttons_description;

  /// No description provided for @settings_show_checklist_button.
  ///
  /// In en, this message translates to:
  /// **'Checklist button'**
  String get settings_show_checklist_button;

  /// No description provided for @settings_show_checklist_button_description.
  ///
  /// In en, this message translates to:
  /// **'Show the button to toggle checklists in the editor\'\'s app bar, hiding it from the editor\'\'s toolbar if enabled'**
  String get settings_show_checklist_button_description;

  /// No description provided for @settings_show_toolbar.
  ///
  /// In en, this message translates to:
  /// **'Toolbar'**
  String get settings_show_toolbar;

  /// No description provided for @settings_show_toolbar_description.
  ///
  /// In en, this message translates to:
  /// **'Show the editor\'\'s toolbar to enable advanced text formatting'**
  String get settings_show_toolbar_description;

  /// No description provided for @settings_focus_title_on_new_note.
  ///
  /// In en, this message translates to:
  /// **'Focus the title'**
  String get settings_focus_title_on_new_note;

  /// No description provided for @settings_focus_title_on_new_note_description.
  ///
  /// In en, this message translates to:
  /// **'Focus the title instead of the content when creating a new note'**
  String get settings_focus_title_on_new_note_description;

  /// No description provided for @settings_use_paragraph_spacing.
  ///
  /// In en, this message translates to:
  /// **'Paragraph spacing'**
  String get settings_use_paragraph_spacing;

  /// No description provided for @settings_use_paragraph_spacing_description.
  ///
  /// In en, this message translates to:
  /// **'Use spacing between paragraphs'**
  String get settings_use_paragraph_spacing_description;

  /// No description provided for @settings_backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settings_backup;

  /// No description provided for @settings_backup_description.
  ///
  /// In en, this message translates to:
  /// **'Export, import'**
  String get settings_backup_description;

  /// No description provided for @settings_backup_auto_export.
  ///
  /// In en, this message translates to:
  /// **'Automatic export'**
  String get settings_backup_auto_export;

  /// No description provided for @settings_backup_manual_export.
  ///
  /// In en, this message translates to:
  /// **'Manual export'**
  String get settings_backup_manual_export;

  /// No description provided for @settings_backup_import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get settings_backup_import;

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

  /// No description provided for @settings_auto_export.
  ///
  /// In en, this message translates to:
  /// **'Automatic export'**
  String get settings_auto_export;

  /// No description provided for @settings_auto_export_description.
  ///
  /// In en, this message translates to:
  /// **'Automatically export the notes to a JSON file (bin included) that can be imported back'**
  String get settings_auto_export_description;

  /// No description provided for @settings_auto_export_frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get settings_auto_export_frequency;

  /// No description provided for @settings_auto_export_frequency_description.
  ///
  /// In en, this message translates to:
  /// **'Automatically export the notes every {frequency, select, 1{day} 7{week} 14{2 weeks} 30{month} other{{frequency} days}}'**
  String settings_auto_export_frequency_description(String frequency);

  /// No description provided for @settings_auto_export_encryption.
  ///
  /// In en, this message translates to:
  /// **'Encryption'**
  String get settings_auto_export_encryption;

  /// No description provided for @settings_auto_export_encryption_description.
  ///
  /// In en, this message translates to:
  /// **'Encrypt the title and the content of the notes with a password'**
  String get settings_auto_export_encryption_description;

  /// No description provided for @settings_auto_export_directory.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get settings_auto_export_directory;

  /// No description provided for @settings_auto_export_directory_description.
  ///
  /// In en, this message translates to:
  /// **'Save the automatic exports in {autoExportDirectory}'**
  String settings_auto_export_directory_description(Object autoExportDirectory);

  /// No description provided for @settings_export_success.
  ///
  /// In en, this message translates to:
  /// **'The notes were successfully exported.'**
  String get settings_export_success;

  /// No description provided for @settings_export_json.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get settings_export_json;

  /// No description provided for @settings_export_json_description.
  ///
  /// In en, this message translates to:
  /// **'Immediately export the notes to a JSON file (bin included) that can be imported back'**
  String get settings_export_json_description;

  /// No description provided for @settings_export_markdown.
  ///
  /// In en, this message translates to:
  /// **'Export as Markdown'**
  String get settings_export_markdown;

  /// No description provided for @settings_export_markdown_description.
  ///
  /// In en, this message translates to:
  /// **'Immediately export the notes to a Markdown file (bin included)'**
  String get settings_export_markdown_description;

  /// No description provided for @settings_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_about;

  /// No description provided for @settings_about_application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get settings_about_application;

  /// No description provided for @settings_about_links.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get settings_about_links;

  /// No description provided for @settings_about_help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get settings_about_help;

  /// No description provided for @settings_about_description.
  ///
  /// In en, this message translates to:
  /// **'Information, help, GitHub, license'**
  String get settings_about_description;

  /// No description provided for @settings_build_mode.
  ///
  /// In en, this message translates to:
  /// **'Build mode'**
  String get settings_build_mode;

  /// No description provided for @settings_build_mode_release.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get settings_build_mode_release;

  /// No description provided for @settings_build_mode_debug.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get settings_build_mode_debug;

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

  /// No description provided for @settings_github_issues.
  ///
  /// In en, this message translates to:
  /// **'Report a bug or request a feature'**
  String get settings_github_issues;

  /// No description provided for @settings_github_issues_description.
  ///
  /// In en, this message translates to:
  /// **'Report a bug or request a feature by creating a GitHub issue'**
  String get settings_github_issues_description;

  /// No description provided for @settings_github_discussions.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get settings_github_discussions;

  /// No description provided for @settings_github_discussions_description.
  ///
  /// In en, this message translates to:
  /// **'Ask a question on GitHub discussions'**
  String get settings_github_discussions_description;

  /// No description provided for @settings_get_in_touch.
  ///
  /// In en, this message translates to:
  /// **'Contact the developer'**
  String get settings_get_in_touch;

  /// No description provided for @settings_get_in_touch_description.
  ///
  /// In en, this message translates to:
  /// **'Contact the developer via mail at {email}'**
  String settings_get_in_touch_description(Object email);

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

  /// No description provided for @tooltip_layout_list.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get tooltip_layout_list;

  /// No description provided for @tooltip_layout_grid.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get tooltip_layout_grid;

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

  /// No description provided for @tooltip_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get tooltip_reset;

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

  /// No description provided for @dialog_auto_export_frequency_slider_label.
  ///
  /// In en, this message translates to:
  /// **'Every {frequency, select, 1{day} 7{week} 14{2 weeks} 30{month} other{{frequency} days}}'**
  String dialog_auto_export_frequency_slider_label(String frequency);

  /// No description provided for @dialog_export_encryption_switch.
  ///
  /// In en, this message translates to:
  /// **'Encrypt the JSON export'**
  String get dialog_export_encryption_switch;

  /// No description provided for @dialog_export_encryption_description.
  ///
  /// In en, this message translates to:
  /// **'The title and the content of the notes will be encrypted using your password. It should be randomly generated, exactly 32 characters long, strong (at least 1 lowercase, 1 uppercase, 1 number and 1 special character) and securely stored.'**
  String get dialog_export_encryption_description;

  /// No description provided for @dialog_export_encryption_secondary_description_auto.
  ///
  /// In en, this message translates to:
  /// **'This password will be used for all future auto exports.'**
  String get dialog_export_encryption_secondary_description_auto;

  /// No description provided for @dialog_export_encryption_secondary_description_manual.
  ///
  /// In en, this message translates to:
  /// **'This password will only be used for this export.'**
  String get dialog_export_encryption_secondary_description_manual;

  /// No description provided for @dialog_export_encryption_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get dialog_export_encryption_password_hint;

  /// No description provided for @dialog_export_encryption_password_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get dialog_export_encryption_password_invalid;

  /// No description provided for @dialog_import_encryption_password_description.
  ///
  /// In en, this message translates to:
  /// **'This export is encrypted. To import it, you need to provide the password used to encrypt it.'**
  String get dialog_import_encryption_password_description;

  /// No description provided for @dialog_import_encryption_password_error.
  ///
  /// In en, this message translates to:
  /// **'the decrypting of the export failed. Please check that you provided the same password that the one you used for encrypting the export.'**
  String get dialog_import_encryption_password_error;

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
  /// **'No deleted notes'**
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

  /// No description provided for @swipe_action_disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get swipe_action_disabled;

  /// No description provided for @swipe_action_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get swipe_action_delete;

  /// No description provided for @swipe_action_pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get swipe_action_pin;

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

  /// No description provided for @action_add_note_title.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get action_add_note_title;

  /// No description provided for @welcome_note_title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Material Notes!'**
  String get welcome_note_title;

  /// No description provided for @welcome_note_content.
  ///
  /// In en, this message translates to:
  /// **'Simple, local, material design notes'**
  String get welcome_note_content;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'pt', 'ru', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
