import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get app_tagline => 'Simple, local, material design notes';

  @override
  String app_about(Object appName) {
    return '$appName is a text-based note-taking application, aimed at simplicity. It embraces Material Design. It stores the notes locally and doesn\'t have any internet permissions, so you are the only one that can access the notes.';
  }

  @override
  String get error_error => 'Error';

  @override
  String get error_permission => 'Failed to get permission to write the file.';

  @override
  String get error_read_file => 'Failed to read the file.';

  @override
  String get navigation_notes => 'Notes';

  @override
  String get navigation_bin => 'Bin';

  @override
  String get navigation_settings => 'Settings';

  @override
  String get navigation_settings_appearance => 'Appearance';

  @override
  String get navigation_settings_behavior => 'Behavior';

  @override
  String get navigation_settings_editor => 'Editor';

  @override
  String get navigation_settings_backup => 'Backup';

  @override
  String get navigation_settings_about => 'About';

  @override
  String get button_ok => 'Ok';

  @override
  String get button_close => 'Close';

  @override
  String get button_cancel => 'Cancel';

  @override
  String get button_add => 'Add';

  @override
  String get settings_appearance => 'Appearance';

  @override
  String get settings_appearance_description => 'Language, theme, notes tiles';

  @override
  String get settings_appearance_application => 'Application';

  @override
  String get settings_appearance_notes_tiles => 'Notes tiles';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_theme => 'Theme';

  @override
  String get settings_theme_system => 'System';

  @override
  String get settings_theme_light => 'Light';

  @override
  String get settings_theme_dark => 'Dark';

  @override
  String get settings_dynamic_theming => 'Dynamic theming';

  @override
  String get settings_dynamic_theming_description => 'Generate colors from the system';

  @override
  String get settings_black_theming => 'Black theming';

  @override
  String get settings_black_theming_description => 'Use a black background in dark mode';

  @override
  String get settings_show_titles_only => 'Titles only';

  @override
  String get settings_show_titles_only_description =>
      'Only show the titles of the notes so more of them can be displayed';

  @override
  String get settings_show_tiles_background => 'Background';

  @override
  String get settings_show_tiles_background_description =>
      'Show the background of the notes tiles to differentiate them easily';

  @override
  String get settings_show_separators => 'Separators';

  @override
  String get settings_show_separators_description =>
      'Show a separator between the notes tiles to differentiate them easily';

  @override
  String get settings_behavior => 'Behavior';

  @override
  String get settings_behavior_application => 'Application';

  @override
  String get settings_behavior_description => 'Confirmations, swipe actions';

  @override
  String get settings_behavior_swipe_actions => 'Swipe actions';

  @override
  String get settings_confirmations => 'Confirmation dialogs';

  @override
  String get settings_confirmations_description =>
      'Show the confirmation dialogs for actions such as pining and deleting notes';

  @override
  String get settings_swipe_action_right => 'Right swipe action';

  @override
  String get settings_swipe_action_right_description =>
      'Action to trigger when a right swipe is performed on the notes tiles';

  @override
  String get settings_swipe_action_left => 'Left swipe action';

  @override
  String get settings_swipe_action_left_description =>
      'Action to trigger when a left swipe is performed on the notes tiles';

  @override
  String get settings_flag_secure => 'Flag the app as secure';

  @override
  String get settings_flag_secure_description =>
      'Hide the app from the recent apps and prevent screenshots from being made';

  @override
  String get settings_editor => 'Editor';

  @override
  String get settings_editor_formatting => 'Formatting';

  @override
  String get settings_editor_appearance => 'Appearance';

  @override
  String get settings_editor_description => 'Buttons, toolbar, spacing';

  @override
  String get settings_show_undo_redo_buttons => 'Undo/redo buttons';

  @override
  String get settings_show_undo_redo_buttons_description =>
      'Show the buttons to undo and redo changes in the editor\'s app bar';

  @override
  String get settings_show_checklist_button => 'Checklist button';

  @override
  String get settings_show_checklist_button_description =>
      'Show the button to toggle checklists in the editor\'s app bar, hiding it from the editor\'s toolbar if enabled';

  @override
  String get settings_show_toolbar => 'Toolbar';

  @override
  String get settings_show_toolbar_description => 'Show the editor\'s toolbar to enable advanced text formatting';

  @override
  String get settings_use_paragraph_spacing => 'Paragraph spacing';

  @override
  String get settings_use_paragraph_spacing_description => 'Use spacing between paragraphs';

  @override
  String get settings_backup => 'Backup';

  @override
  String get settings_backup_description => 'Export, import';

  @override
  String get settings_backup_export => 'Export';

  @override
  String get settings_backup_import => 'Import';

  @override
  String get settings_auto_export => 'Auto export as JSON';

  @override
  String get settings_auto_export_description =>
      'Automatically export the notes to a JSON file (bin included) that can be imported back';

  @override
  String settings_auto_export_value(String encrypt, String frequency) {
    String _temp0 = intl.Intl.selectLogic(
      frequency,
      {
        '1': 'day',
        '7': 'week',
        '14': '2 weeks',
        '30': 'month',
        'other': '$frequency days',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      encrypt,
      {
        'true': 'encrypted',
        'false': 'not encrypted',
        'other': '',
      },
    );
    return 'Every $_temp0, $_temp1';
  }

  @override
  String get settings_auto_export_disabled => 'Disabled';

  @override
  String settings_auto_export_directory(Object directory) {
    return 'Exports can be found in $directory';
  }

  @override
  String get settings_auto_export_dialog_description_disabled => 'Auto export will be disabled.';

  @override
  String settings_auto_export_dialog_description_enabled(String frequency) {
    String _temp0 = intl.Intl.selectLogic(
      frequency,
      {
        '1': 'day',
        '7': 'week',
        '14': '2 weeks',
        '30': 'month',
        'other': '$frequency days',
      },
    );
    return 'Auto export will be performed every $_temp0. Set the frequency to 0 to disable it.';
  }

  @override
  String settings_auto_export_dialog_slider_label(String frequency) {
    String _temp0 = intl.Intl.selectLogic(
      frequency,
      {
        '1': 'day',
        '7': 'week',
        '14': '2 weeks',
        '30': 'month',
        'other': '$frequency days',
      },
    );
    return 'Every $_temp0';
  }

  @override
  String get settings_export_success => 'The notes were successfully exported.';

  @override
  String get settings_export_json => 'Export as JSON';

  @override
  String get settings_export_json_description =>
      'Immediately export the notes to a JSON file (bin included) that can be imported back';

  @override
  String get settings_export_markdown => 'Export as Markdown';

  @override
  String get settings_export_markdown_description => 'Immediately export the notes to a Markdown file (bin included)';

  @override
  String get settings_import => 'Import';

  @override
  String get settings_import_description => 'Import notes from a JSON file';

  @override
  String get settings_import_success => 'The notes were successfully imported.';

  @override
  String get settings_about => 'About';

  @override
  String get settings_about_application => 'Application';

  @override
  String get settings_about_links => 'Links';

  @override
  String get settings_about_help => 'Help';

  @override
  String get settings_about_description => 'Information, help, GitHub, license';

  @override
  String get settings_build_mode => 'Build mode';

  @override
  String get settings_build_mode_release => 'Release';

  @override
  String get settings_build_mode_debug => 'Debug';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Take a look at the source code';

  @override
  String get settings_licence => 'License';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get settings_github_issues => 'Report a bug';

  @override
  String get settings_github_issues_description => 'Report a bug by creating a GitHub issue';

  @override
  String get settings_github_discussions => 'Ask a question';

  @override
  String get settings_github_discussions_description => 'Ask a question on GitHub discussions';

  @override
  String get settings_get_in_touch => 'Contact the developer';

  @override
  String get settings_get_in_touch_description => 'Contact the developer via mail at contact@maelchiotti.dev';

  @override
  String get hint_title => 'Title';

  @override
  String get hint_note => 'Note';

  @override
  String get tooltip_fab_add_note => 'Add a note';

  @override
  String get tooltip_fab_empty_bin => 'Empty the bin';

  @override
  String get tooltip_layout_list => 'List view';

  @override
  String get tooltip_layout_grid => 'Grid view';

  @override
  String get tooltip_sort => 'Sort the notes';

  @override
  String get tooltip_search => 'Search the notes';

  @override
  String get tooltip_toggle_checkbox => 'Toggle checkbox';

  @override
  String get tooltip_select_all => 'Select all';

  @override
  String get tooltip_unselect_all => 'Unselect all';

  @override
  String get tooltip_delete => 'Delete';

  @override
  String get tooltip_permanently_delete => 'Permanently delete';

  @override
  String get tooltip_restore => 'Restore';

  @override
  String get tooltip_toggle_pins => 'Toggle pins';

  @override
  String get dialog_delete => 'Delete';

  @override
  String dialog_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notes',
      one: 'note',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'them',
      one: 'it',
      zero: '',
    );
    return 'Do you really want to delete $count $_temp0? You can restore $_temp1 from the bin.';
  }

  @override
  String get dialog_delete_body_single => 'Do you really want to delete this note? You can restore it from the bin.';

  @override
  String get dialog_permanently_delete => 'Delete permanently';

  @override
  String dialog_permanently_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notes',
      one: 'note',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'them',
      one: 'it',
      zero: '',
    );
    return 'Do you really want to permanently delete $count $_temp0? You will not be able to restore $_temp1.';
  }

  @override
  String get dialog_permanently_delete_body_single =>
      'Do you really want to permanently delete this note? You will not be able to restore it.';

  @override
  String get dialog_restore => 'Restore';

  @override
  String dialog_restore_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notes',
      one: 'note',
      zero: '',
    );
    return 'Do you really want to restore $count $_temp0?';
  }

  @override
  String get dialog_restore_body_single => 'Do you really want to restore this note?';

  @override
  String get dialog_empty_bin => 'Empty the bin';

  @override
  String get dialog_empty_bin_body =>
      'Do you really want to permanently empty the bin? You will not be able to restore the notes it contains.';

  @override
  String get dialog_export_encryption_switch => 'Encrypt the JSON export';

  @override
  String get dialog_export_encryption_description =>
      'The title and the content of the notes will be encrypted using your password. It should be randomly generated, exactly 32 characters long, strong (at least 1 lowercase, 1 uppercase, 1 number and 1 special character) and securely stored.';

  @override
  String get dialog_export_encryption_secondary_description_auto =>
      'This password will be used for all future auto exports.';

  @override
  String get dialog_export_encryption_secondary_description_manual =>
      'This password will only be used for this export.';

  @override
  String get dialog_export_encryption_password_hint => 'Password';

  @override
  String get dialog_export_encryption_password_invalid => 'Invalid';

  @override
  String get dialog_import_encryption_password_description =>
      'This export is encrypted. To import it, you need to provide the password used to encrypt it.';

  @override
  String get dialog_import_encryption_password_error =>
      'the decrypting of the export failed. Please check that you provided the same password that the one you used for encrypting the export.';

  @override
  String get sort_date => 'Date';

  @override
  String get sort_title => 'Title';

  @override
  String get sort_ascending => 'Ascending';

  @override
  String get placeholder_notes => 'No notes';

  @override
  String get placeholder_bin => 'No deleted notes';

  @override
  String get menu_pin => 'Pin';

  @override
  String get menu_share => 'Share';

  @override
  String get menu_unpin => 'Unpin';

  @override
  String get menu_delete => 'Delete';

  @override
  String get menu_restore => 'Restore';

  @override
  String get menu_delete_permanently => 'Delete permanently';

  @override
  String get menu_about => 'About';

  @override
  String get confirmations_title_none => 'Never';

  @override
  String get confirmations_title_irreversible => 'Irreversible actions only';

  @override
  String get confirmations_title_all => 'Always';

  @override
  String get swipe_action_disabled => 'Disabled';

  @override
  String get swipe_action_delete => 'Delete';

  @override
  String get swipe_action_pin => 'Pin';

  @override
  String get dismiss_pin => 'Pin';

  @override
  String get dismiss_unpin => 'Unpin';

  @override
  String get dismiss_delete => 'Delete';

  @override
  String get about_last_edited => 'Last edited';

  @override
  String get about_created => 'Created';

  @override
  String get about_words => 'Words';

  @override
  String get about_characters => 'Characters';

  @override
  String get time_at => 'at';

  @override
  String get action_add_note_title => 'Add a note';

  @override
  String get welcome_note_title => 'Welcome to Material Notes!';

  @override
  String get welcome_note_content => 'Simple, local, material design notes';
}
