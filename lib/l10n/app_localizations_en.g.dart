import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

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
  String get navigation_notes => 'Notes';

  @override
  String get navigation_bin => 'Bin';

  @override
  String get navigation_settings => 'Settings';

  @override
  String get error_error => 'Error';

  @override
  String get error_permission => 'Failed to get permission to write the file.';

  @override
  String get error_read_file => 'Failed to read the file.';

  @override
  String get settings_appearance => 'Appearance';

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
  String get settings_dynamic_theming_description => 'Generate colors from your system';

  @override
  String get settings_black_theming => 'Black theming';

  @override
  String get settings_black_theming_description => 'Use a black background in dark mode';

  @override
  String get settings_language => 'Language';

  @override
  String get settings_separator => 'Show the separators';

  @override
  String get settings_separator_description => 'Show a separator between notes to differentiate them easily';

  @override
  String get settings_behavior => 'Behavior';

  @override
  String get settings_confirmations => 'Show confirmation dialogs';

  @override
  String get settings_backup => 'Backup';

  @override
  String get settings_export_json => 'Export as JSON';

  @override
  String get settings_export_markdown => 'Export as Markdown';

  @override
  String get settings_export_json_description => 'Export notes to a JSON file (bin included) that can be imported back';

  @override
  String get settings_export_markdown_description => 'Export notes to a Markdown file (bin included)';

  @override
  String get settings_export_success => 'The notes were successfully exported.';

  @override
  String get settings_import => 'Import';

  @override
  String get settings_import_description => 'Import notes from a JSON file';

  @override
  String get settings_import_success => 'The notes were successfully imported.';

  @override
  String get settings_about => 'About';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Take a look at the source code';

  @override
  String get settings_licence => 'License';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get settings_issue => 'Report a bug';

  @override
  String get settings_issue_description => 'Report a bug by creating an issue on GitHub';

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
  String get button_ok => 'Ok';

  @override
  String get button_close => 'Close';

  @override
  String get button_cancel => 'Cancel';

  @override
  String get button_add => 'Add';

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
  String get sort_date => 'Date';

  @override
  String get sort_title => 'Title';

  @override
  String get sort_ascending => 'Ascending';

  @override
  String get placeholder_notes => 'No notes';

  @override
  String get placeholder_bin => 'The bin is empty';

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
  String get notes_untitled => 'Untitled note';

  @override
  String get confirmations_title_none => 'Never';

  @override
  String get confirmations_title_irreversible => 'Irreversible actions only';

  @override
  String get confirmations_title_all => 'Always';

  @override
  String get dismiss_pin => 'Pin';

  @override
  String get dismiss_unpin => 'Unpin';

  @override
  String get dismiss_delete => 'Delete';

  @override
  String get dismiss_permanently_delete => 'Permanently delete';

  @override
  String get dismiss_restore => 'Restore';

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
}
