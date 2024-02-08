import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get navigation_notes => 'Notes';

  @override
  String get navigation_bin => 'Bin';

  @override
  String get navigation_settings => 'Settings';

  @override
  String get error_error => 'Error';

  @override
  String get error_wrong_email_password => 'Wrong username or password.';

  @override
  String get error_confirm_email => 'Please confirm your email and then try again.';

  @override
  String get error_invalid_email => 'Invalid email';

  @override
  String get error_required => 'Required';

  @override
  String get error_password_requirements =>
      'Requirements:\n• 12 characters\n• 1 lower case\n• 1 upper case\n• 1 number\n• 1 special character (!@#\$&%*^\"\'`<>+=-;:~,._;/\\|()[]{})';

  @override
  String get error_password_do_not_match => 'Passwords do not match';

  @override
  String get error_access_external_storage_required =>
      'Please grant access to external storage or save the file to the internal storage.';

  @override
  String get login_email => 'Email';

  @override
  String get login_password => 'Password';

  @override
  String get login_log_in => 'Log in';

  @override
  String get login_log_out => 'Log out';

  @override
  String get signup_sign_up => 'Sign up';

  @override
  String get signup_email => 'Email';

  @override
  String get signup_password => 'Password';

  @override
  String get signup_password_confirmation => 'Confirm your password';

  @override
  String get signup_confirm_email => 'Please confirm your email before signing in.';

  @override
  String get settings_account => 'Account';

  @override
  String get settings_user => 'User';

  @override
  String get settings_log_out => 'Log out';

  @override
  String settings_log_out_description(Object appName) {
    return 'Log out of $appName';
  }

  @override
  String get settings_change_password => 'Change my password';

  @override
  String settings_change_password_description(Object appName) {
    return 'Change my password for $appName';
  }

  @override
  String get settings_change_password_success => 'Your password has been changed, please log back in.';

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
  String get settings_language_restart => 'Please restart the app for the changes to take effect.';

  @override
  String get settings_behavior => 'Behavior';

  @override
  String get settings_confirmations => 'Show confirmation dialogs';

  @override
  String get settings_shortcuts => 'Shortcuts';

  @override
  String get settings_shortcuts_description => 'Show all shortcuts available in the text editor';

  @override
  String get settings_backup => 'Backup';

  @override
  String get settings_export => 'Export';

  @override
  String get settings_export_description => 'Export notes to a JSON file (bin included)';

  @override
  String get settings_export_success => 'The notes were successfully exported.';

  @override
  String settings_export_fail(Object error) {
    return 'The export failed: $error.';
  }

  @override
  String get settings_import => 'Import';

  @override
  String get settings_import_description => 'Import notes from a JSON file';

  @override
  String get settings_import_success => 'The notes were successfully imported.';

  @override
  String settings_import_fail(Object error) {
    return 'The import failed: $error.';
  }

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
  String get shortcut_bold => 'Bold';

  @override
  String get shortcut_italic => 'Italic';

  @override
  String get shortcut_underline => 'Underline';

  @override
  String get shortcut_undo => 'Undo';

  @override
  String get shortcut_redo => 'Redo';

  @override
  String get action_add_note => 'Add a note';

  @override
  String get label_old_password => 'Old password';

  @override
  String get label_new_password => 'New password';

  @override
  String get label_new_password_confirmation => 'Confirm new password';

  @override
  String get hint_email => 'Email';

  @override
  String get hint_password => 'Password';

  @override
  String get hint_password_confirmation => 'Confirm password';

  @override
  String get hint_old_password => 'myOldPassword';

  @override
  String get hint_new_password => 'myNewPassword';

  @override
  String get hint_new_password_confirmation => 'myNewPassword';

  @override
  String get hint_title => 'Title';

  @override
  String get hint_collaborator_email => 'collaborator@example.com';

  @override
  String get tooltip_fab_add_note => 'Add a note';

  @override
  String get tooltip_fab_empty_bin => 'Empty the bin';

  @override
  String get tooltip_fab_add_collaborator => 'Add a collaborator';

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
  String get button_close => 'Close';

  @override
  String get button_cancel => 'Cancel';

  @override
  String get button_refresh => 'Refresh';

  @override
  String get button_add => 'Add';

  @override
  String get dialog_log_out => 'Log out';

  @override
  String get dialog_log_out_body => 'Do you really want to log out?';

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
  String get dialog_add_collaborator => 'Add a collaborator';

  @override
  String get dialog_remove_collaborator => 'Remove this collaborator';

  @override
  String get dialog_remove_collaborator_body => 'Do you really want to remove this collaborator?';

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
  String get placeholder_collaborators => 'No collaborators';

  @override
  String get menu_pin => 'Pin';

  @override
  String get menu_share => 'Share';

  @override
  String get menu_unpin => 'Unpin';

  @override
  String get menu_collaborate => 'Collaborate';

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
  String get confirmations_description_none => 'Never ask for a confirmation';

  @override
  String get confirmations_description_irreversible =>
      'Only ask for a confirmation for actions that are not reversible (such as permanently deleting notes from the bin)';

  @override
  String get confirmations_description_all =>
      'Always ask for a confirmation for all important actions even if they can be reversed (such as deleting or restoring a note)';

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
  String get collaborators_collaborators => 'Collaborators';

  @override
  String get collaborators_owner => 'Owner';

  @override
  String get collaborators_guest => 'Guest';

  @override
  String get collaborators_owner_description =>
      'You are the owner of this note.\n\nYou can add or remove collaborators. If you delete this note, all collaborators will loose access to it. They will gain access back if you restore it.\n\nLimitations:\n- You cannot remove yourself from the collaborators.\n- The pinned state is shared among every collaborator.';

  @override
  String get collaborators_guest_description =>
      'You were invited as a collaborator to this note.\n\nYou cannot add or remove collaborators, only the owner can.\n\nLimitations:\n- You cannot remove yourself from the collaborators.\n- The pinned state is shared among every collaborator.';

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