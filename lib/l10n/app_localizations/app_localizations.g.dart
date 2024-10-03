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
import 'app_localizations_zh.g.dart';

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
    Locale('tr'),
    Locale('zh')
  ];

  /// Name of the application.
  ///
  /// In en, this message translates to:
  /// **'Material Notes'**
  String get app_name;

  /// Tagline of the application, shown in the about popup.
  ///
  /// In en, this message translates to:
  /// **'Simple, local, material design notes'**
  String get app_tagline;

  /// Description of the application, shown in the about popup.
  ///
  /// In en, this message translates to:
  /// **'{appName} is a text-based note-taking application, aimed at simplicity. It embraces Material Design. It stores the notes locally and doesn\'\'t have any internet permissions, so you are the only one that can access the notes.'**
  String app_about(String appName);

  /// Error message, shown in the error snack bar before the actual error message.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_error;

  /// Title of the notes page.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get navigation_notes;

  /// Title of the bin page.
  ///
  /// In en, this message translates to:
  /// **'Bin'**
  String get navigation_bin;

  /// Title of the settings page.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navigation_settings;

  /// Title of the settings page regarding the application's appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get navigation_settings_appearance;

  /// Title of the settings page regarding the application's behavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get navigation_settings_behavior;

  /// Title of the settings page regarding the notes content editor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get navigation_settings_editor;

  /// Title of the settings page regarding the backup functionality.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get navigation_settings_backup;

  /// Title of the settings page regarding the information about the application.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get navigation_settings_about;

  /// Button to validate a dialog.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get button_ok;

  /// Button to cancel and close a dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get button_cancel;

  /// Title of the settings section regarding the application's appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_appearance;

  /// Description of the appearance settings section.
  ///
  /// In en, this message translates to:
  /// **'Language, theme, text scaling, notes tiles'**
  String get settings_appearance_description;

  /// Title of the sub-section regarding the application under the appearance settings.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get settings_appearance_application;

  /// Title of the language setting tile.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// Button to contribute to the localizations, shown on the language setting tile.
  ///
  /// In en, this message translates to:
  /// **'Contribute'**
  String get settings_language_contribute;

  /// Title of the theming setting tile.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_theme;

  /// Theming setting to use the theme of the system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_theme_system;

  /// Theming setting to use the light theme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_theme_light;

  /// Theming setting to use the dark theme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_theme_dark;

  /// Title of the dynamic theming setting tile (to use colors generated from the system).
  ///
  /// In en, this message translates to:
  /// **'Dynamic theming'**
  String get settings_dynamic_theming;

  /// Description of the dynamic theming setting tile.
  ///
  /// In en, this message translates to:
  /// **'Generate colors from the system'**
  String get settings_dynamic_theming_description;

  /// Title of the black theming setting tile (to use a black background in dark mode).
  ///
  /// In en, this message translates to:
  /// **'Black theming'**
  String get settings_black_theming;

  /// Description of the black theming setting tile.
  ///
  /// In en, this message translates to:
  /// **'Use a black background in dark mode'**
  String get settings_black_theming_description;

  /// Title of the text scale setting tile.
  ///
  /// In en, this message translates to:
  /// **'Text scaling'**
  String get settings_text_scaling;

  /// Title of the sub-section regarding the notes tiles under the appearance settings.
  ///
  /// In en, this message translates to:
  /// **'Notes tiles'**
  String get settings_appearance_notes_tiles;

  /// Title of the setting tile to only show the titles of the notes in the notes tiles.
  ///
  /// In en, this message translates to:
  /// **'Titles only'**
  String get settings_show_titles_only;

  /// Description of the setting tile to only show the titles of the notes in the notes tiles.
  ///
  /// In en, this message translates to:
  /// **'Only show the titles of the notes'**
  String get settings_show_titles_only_description;

  /// Title of the setting tile to disable only showing the titles of the notes in the search view.
  ///
  /// In en, this message translates to:
  /// **'Disable titles only in search view'**
  String get settings_show_titles_only_disable_in_search_view;

  /// Description of the setting tile to disable only showing the titles of the notes in the search view.
  ///
  /// In en, this message translates to:
  /// **'Disable the option to only show the titles when in the search view'**
  String get settings_show_titles_only_disable_in_search_view_description;

  /// Title of the setting tile to disable the subdued color of the notes content preview text in the notes tiles.
  ///
  /// In en, this message translates to:
  /// **'Non-subdued preview'**
  String get settings_disable_subdued_note_content_preview;

  /// Description of the setting tile to disable the subdued color of the notes content preview text in the notes tiles.
  ///
  /// In en, this message translates to:
  /// **'Disable the subdued text color of the notes content preview'**
  String get settings_disable_subdued_note_content_preview_description;

  /// Title of the setting tile to show the background of the notes tiles.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get settings_show_tiles_background;

  /// Description of the setting tile to show the background of the notes tiles.
  ///
  /// In en, this message translates to:
  /// **'Show the background of the notes tiles'**
  String get settings_show_tiles_background_description;

  /// Title of the setting tile to show the separators between the notes tiles.
  ///
  /// In en, this message translates to:
  /// **'Separators'**
  String get settings_show_separators;

  /// Description of the setting tile to show the separators between the notes tiles.
  ///
  /// In en, this message translates to:
  /// **'Show a separator between the notes tiles'**
  String get settings_show_separators_description;

  /// Title of the settings section regarding the application's behavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get settings_behavior;

  /// Description of the behavior settings section.
  ///
  /// In en, this message translates to:
  /// **'Confirmations, secure flag, swipe actions'**
  String get settings_behavior_description;

  /// Title of the sub-section regarding the application under the behavior settings.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get settings_behavior_application;

  /// Title of the setting tile to choose when to show the confirmation dialog when performing an action on a note.
  ///
  /// In en, this message translates to:
  /// **'Confirmation dialog'**
  String get settings_confirmations;

  /// Description of the setting tile to choose when to show the confirmation dialog when performing an action on a note.
  ///
  /// In en, this message translates to:
  /// **'When to show a confirmation dialog when performing an action on a note'**
  String get settings_confirmations_description;

  /// Title of the setting tile to flag the application as secure (hiding it from the recent apps and prevent screenshots from being made).
  ///
  /// In en, this message translates to:
  /// **'Flag the app as secure'**
  String get settings_flag_secure;

  /// Description of the setting tile to flag the application as secure (hiding it from the recent apps and prevent screenshots from being made).
  ///
  /// In en, this message translates to:
  /// **'Hide the app from the recent apps and prevent screenshots from being made'**
  String get settings_flag_secure_description;

  /// Title of the sub-section regarding the swipe actions under the behavior settings.
  ///
  /// In en, this message translates to:
  /// **'Swipe actions'**
  String get settings_behavior_swipe_actions;

  /// Title of the setting tile to choose which action to trigger when a right swapping a note tile.
  ///
  /// In en, this message translates to:
  /// **'Right swipe action'**
  String get settings_swipe_action_right;

  /// Description of the setting tile to choose which action to trigger when a right swipe is performed on a note tile.
  ///
  /// In en, this message translates to:
  /// **'Action to trigger when a right swipe is performed on a note tile'**
  String get settings_swipe_action_right_description;

  /// Title of the setting tile to choose which action to trigger when a left swipe is performed on a note tile.
  ///
  /// In en, this message translates to:
  /// **'Left swipe action'**
  String get settings_swipe_action_left;

  /// Description of the setting tile to choose which action to trigger when a left swipe is performed on a note tile.
  ///
  /// In en, this message translates to:
  /// **'Action to trigger when a left swipe is performed on a note tile'**
  String get settings_swipe_action_left_description;

  /// Title of the settings section regarding the notes content editor.
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get settings_editor;

  /// Description of the editor settings section.
  ///
  /// In en, this message translates to:
  /// **'Buttons, toolbar, reading mode, spacing'**
  String get settings_editor_description;

  /// Title of the settings section regarding the notes content formatting in the editor.
  ///
  /// In en, this message translates to:
  /// **'Formatting'**
  String get settings_editor_formatting;

  /// Title of the setting tile to enable the the undo and redo buttons in the editor.
  ///
  /// In en, this message translates to:
  /// **'Undo/redo buttons'**
  String get settings_show_undo_redo_buttons;

  /// Description of the setting tile to enable the the undo and redo buttons in the editor.
  ///
  /// In en, this message translates to:
  /// **'Show the buttons to undo and redo changes in the editor\'\'s app bar'**
  String get settings_show_undo_redo_buttons_description;

  /// Title of the setting tile to enable the checklist button in the editor.
  ///
  /// In en, this message translates to:
  /// **'Checklist button'**
  String get settings_show_checklist_button;

  /// Description of the setting tile to enable the checklist button in the editor.
  ///
  /// In en, this message translates to:
  /// **'Show the button to toggle checklists in the editor\'\'s app bar, hiding it from the editor\'\'s toolbar if enabled'**
  String get settings_show_checklist_button_description;

  /// Title of the setting tile to enable the toolbar for advanced formatting options in the editor.
  ///
  /// In en, this message translates to:
  /// **'Toolbar'**
  String get settings_show_toolbar;

  /// Description of the setting tile to enable the toolbar for advanced formatting options in the editor.
  ///
  /// In en, this message translates to:
  /// **'Show the editor\'\'s toolbar to enable advanced text formatting'**
  String get settings_show_toolbar_description;

  /// Title of the settings section regarding the behavior of the editor
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get settings_editor_behavior;

  /// Title of the setting tile to enable the button to toggle between editing mode and reading mode in the editor.
  ///
  /// In en, this message translates to:
  /// **'Editor mode button'**
  String get settings_show_editor_mode_button;

  /// Description of the setting tile to enable the button to toggle between editing mode and reading mode in the editor.
  ///
  /// In en, this message translates to:
  /// **'Enable the button to toggle the editor between editing mode and reading mode'**
  String get settings_show_editor_mode_button_description;

  /// Title of the setting tile to enable opening the editor in reading mode by default.
  ///
  /// In en, this message translates to:
  /// **'Open in reading mode'**
  String get settings_open_editor_reading_mode;

  /// Description of the setting tile to enable opening the editor in reading mode by default.
  ///
  /// In en, this message translates to:
  /// **'Open the editor in reading mode by default'**
  String get settings_open_editor_reading_mode_description;

  /// Title of the setting tile to enable focusing the title when creating a new note by default.
  ///
  /// In en, this message translates to:
  /// **'Focus the title'**
  String get settings_focus_title_on_new_note;

  /// Description of the setting tile to enable focusing the title when creating a new note by default.
  ///
  /// In en, this message translates to:
  /// **'Focus the title instead of the content when creating a new note'**
  String get settings_focus_title_on_new_note_description;

  /// Title of the settings section regarding the appearance of the editor
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_editor_appearance;

  /// Title of the setting tile to enable the spacing between paragraphs in the notes content.
  ///
  /// In en, this message translates to:
  /// **'Paragraph spacing'**
  String get settings_use_paragraph_spacing;

  /// Description of the setting tile to enable the spacing between paragraphs in the notes content.
  ///
  /// In en, this message translates to:
  /// **'Use spacing between paragraphs'**
  String get settings_use_paragraph_spacing_description;

  /// Title of the settings section regarding the backup functionality.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settings_backup;

  /// Description of the backup settings section.
  ///
  /// In en, this message translates to:
  /// **'Manual and auto export, encryption, import'**
  String get settings_backup_description;

  /// Title of the settings section regarding the import of a backup.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get settings_backup_import;

  /// Title of the setting tile to import a backup.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get settings_import;

  /// Description of the setting tile to import a backup.
  ///
  /// In en, this message translates to:
  /// **'Import notes from a JSON file'**
  String get settings_import_description;

  /// Title of the settings section regarding the manual export of the notes.
  ///
  /// In en, this message translates to:
  /// **'Manual export'**
  String get settings_backup_manual_export;

  /// Title of the setting tile to manually export the notes as JSON.
  ///
  /// In en, this message translates to:
  /// **'Export as JSON'**
  String get settings_export_json;

  /// Description of the setting tile to manually export the notes as JSON.
  ///
  /// In en, this message translates to:
  /// **'Immediately export the notes to a JSON file (bin included) that can be imported back'**
  String get settings_export_json_description;

  /// Title of the setting tile to manually export the notes as Markdown.
  ///
  /// In en, this message translates to:
  /// **'Export as Markdown'**
  String get settings_export_markdown;

  /// Description of the setting tile to manually export the notes as Markdown.
  ///
  /// In en, this message translates to:
  /// **'Immediately export the notes to a Markdown file (bin included)'**
  String get settings_export_markdown_description;

  /// Title of the settings section regarding the automatic export of the notes.
  ///
  /// In en, this message translates to:
  /// **'Automatic export'**
  String get settings_backup_auto_export;

  /// Title of the settings tile to enable the automatic export of the notes.
  ///
  /// In en, this message translates to:
  /// **'Automatic export'**
  String get settings_auto_export;

  /// Description of the settings tile to enable the automatic export of the notes.
  ///
  /// In en, this message translates to:
  /// **'Automatically export the notes to a JSON file (bin included) that can be imported back'**
  String get settings_auto_export_description;

  /// Title of the settings tile to choose the frequency of the automatic exports of the notes.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get settings_auto_export_frequency;

  /// Frequency of the automatic exports of the notes.
  ///
  /// In en, this message translates to:
  /// **'Every {frequency, select, 1{day} 7{week} 14{2 weeks} 30{month} other{{frequency} days}}'**
  String settings_auto_export_frequency_value(String frequency);

  /// Description of the settings tile to choose the frequency of the automatic exports of the notes.
  ///
  /// In en, this message translates to:
  /// **'Frequency of the automatic export of the notes'**
  String get settings_auto_export_frequency_description;

  /// Title of the settings tile to enable the encryption of the automatic exports.
  ///
  /// In en, this message translates to:
  /// **'Encryption'**
  String get settings_auto_export_encryption;

  /// Description of the settings tile to enable the encryption of the automatic exports.
  ///
  /// In en, this message translates to:
  /// **'Encrypt the title and the content of the notes with a password'**
  String get settings_auto_export_encryption_description;

  /// Title of the settings tile to choose the directory where to save the automatic exports.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get settings_auto_export_directory;

  /// Description of the settings tile to choose the directory where to save the automatic exports.
  ///
  /// In en, this message translates to:
  /// **'Directory where to store the automatic exports of the notes'**
  String get settings_auto_export_directory_description;

  /// Title of the settings section regarding the information about the application.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settings_about;

  /// Description of the about settings section.
  ///
  /// In en, this message translates to:
  /// **'Information, help, links'**
  String get settings_about_description;

  /// Title of the settings section regarding the information about the application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get settings_about_application;

  /// Title of the settings tile displaying the build mode of the application.
  ///
  /// In en, this message translates to:
  /// **'Build mode'**
  String get settings_build_mode;

  /// Value of the settings tile displaying the build mode if the application is built in release mode (the mode used in the stores).
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get settings_build_mode_release;

  /// Value of the settings tile displaying the build mode if the application is built in debug mode (the mode used for development and ).
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get settings_build_mode_debug;

  /// Title of the settings section regarding how to get help for the application.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get settings_about_help;

  /// Title of the settings tile to open the GitHub issues and report a bug or request a feature.
  ///
  /// In en, this message translates to:
  /// **'Report a bug or request a feature'**
  String get settings_github_issues;

  /// Description of the settings tile to open the GitHub issues and report a bug or request a feature.
  ///
  /// In en, this message translates to:
  /// **'Report a bug or request a feature by creating a GitHub issue'**
  String get settings_github_issues_description;

  /// Title of the settings tile to open the GitHub discussions and ask a question.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get settings_github_discussions;

  /// Description of the settings tile to open the GitHub discussions and ask a question.
  ///
  /// In en, this message translates to:
  /// **'Ask a question on GitHub discussions'**
  String get settings_github_discussions_description;

  /// Title of the settings tile to contact the developer via mail.
  ///
  /// In en, this message translates to:
  /// **'Contact the developer'**
  String get settings_get_in_touch;

  /// Description of the settings tile to contact the developer via mail.
  ///
  /// In en, this message translates to:
  /// **'Contact the developer via mail at {email}'**
  String settings_get_in_touch_description(Object email);

  /// Title of the settings section regarding the outside links related to the application.
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get settings_about_links;

  /// Title of the settings tile to open the GitHub repository of the application.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get settings_github;

  /// Description of the settings tile to open the GitHub repository of the application.
  ///
  /// In en, this message translates to:
  /// **'Take a look at the source code'**
  String get settings_github_description;

  /// Title of the settings tile to open the Crowdin project managing the localization of the application.
  ///
  /// In en, this message translates to:
  /// **'Crowdin'**
  String get settings_localizations;

  /// Description of the settings tile to open the Crowdin project managing the localization of the application.
  ///
  /// In en, this message translates to:
  /// **'Add or improve the localizations on the Crowdin project'**
  String get settings_localizations_description;

  /// Title of the settings tile to open the license of the application.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get settings_licence;

  /// Description of the settings tile to open the license of the application.
  ///
  /// In en, this message translates to:
  /// **'AGPL-3.0'**
  String get settings_licence_description;

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

  /// No description provided for @tooltip_fab_toggle_editor_mode_edit.
  ///
  /// In en, this message translates to:
  /// **'Switch to editing mode'**
  String get tooltip_fab_toggle_editor_mode_edit;

  /// No description provided for @tooltip_fab_toggle_editor_mode_read.
  ///
  /// In en, this message translates to:
  /// **'Switch to reading mode'**
  String get tooltip_fab_toggle_editor_mode_read;

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

  /// No description provided for @dialog_add_link.
  ///
  /// In en, this message translates to:
  /// **'Add a link'**
  String get dialog_add_link;

  /// No description provided for @dialog_link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get dialog_link;

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

  /// No description provided for @action_disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get action_disabled;

  /// No description provided for @action_pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get action_pin;

  /// No description provided for @action_unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get action_unpin;

  /// No description provided for @action_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get action_copy;

  /// No description provided for @action_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get action_share;

  /// No description provided for @action_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get action_delete;

  /// No description provided for @action_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get action_restore;

  /// No description provided for @action_delete_permanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get action_delete_permanently;

  /// No description provided for @action_about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get action_about;

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

  /// No description provided for @snack_bar_copied.
  ///
  /// In en, this message translates to:
  /// **'Content of the note copied to the clipboard.'**
  String get snack_bar_copied;

  ///
  ///
  /// In en, this message translates to:
  /// **'The notes were successfully imported.'**
  String get snack_bar_import_success;

  ///
  ///
  /// In en, this message translates to:
  /// **'The notes were successfully exported.'**
  String get snack_bar_export_success;

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
  bool isSupported(Locale locale) => <String>['en', 'es', 'fr', 'pt', 'ru', 'tr', 'zh'].contains(locale.languageCode);

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
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError('AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
