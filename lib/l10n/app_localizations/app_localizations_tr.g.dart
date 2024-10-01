import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get app_tagline => 'Basit, çevrimdışı, materyal tasarımlı notlar';

  @override
  String app_about(String appName) {
    return '$appName basitliği hedefleyen metin tabanlı bir not alma uygulamasıdır. Materyal Tasarımı benimser. Notları yerel olarak saklar ve internet izni yoktur, böylece notlara erişebilen tek kişi sizsiniz.';
  }

  @override
  String get error_error => 'Hata';

  @override
  String get navigation_notes => 'Notlar';

  @override
  String get navigation_bin => 'Çöp Kutusu';

  @override
  String get navigation_settings => 'Ayarlar';

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
  String get button_ok => 'Tamam';

  @override
  String get button_cancel => 'İptal et';

  @override
  String get settings_appearance => 'Görünüş';

  @override
  String get settings_appearance_description => 'Language, theme, notes tiles';

  @override
  String get settings_appearance_application => 'Application';

  @override
  String get settings_language => 'Dil';

  @override
  String get settings_language_contribute => 'Contribute';

  @override
  String get settings_theme => 'Tema';

  @override
  String get settings_theme_system => 'Sistem';

  @override
  String get settings_theme_light => 'Açık';

  @override
  String get settings_theme_dark => 'Koyu';

  @override
  String get settings_dynamic_theming => 'Dinamik tema';

  @override
  String get settings_dynamic_theming_description => 'Generate colors from the system';

  @override
  String get settings_black_theming => 'Siyah tema';

  @override
  String get settings_black_theming_description => 'Koyu modda siyah arkaplan kullanın';

  @override
  String get settings_text_scaling => 'Text scaling';

  @override
  String get settings_appearance_notes_tiles => 'Notes tiles';

  @override
  String get settings_show_titles_only => 'Titles only';

  @override
  String get settings_show_titles_only_description => 'Only show the titles of the notes';

  @override
  String get settings_show_titles_only_disable_in_search_view => 'Disable titles only in search view';

  @override
  String get settings_show_titles_only_disable_in_search_view_description =>
      'Disable the option to only show the titles when in the search view';

  @override
  String get settings_disable_subdued_note_content_preview => 'Non-subdued preview';

  @override
  String get settings_disable_subdued_note_content_preview_description =>
      'Disable the subdued text color of the notes content preview';

  @override
  String get settings_show_tiles_background => 'Background';

  @override
  String get settings_show_tiles_background_description => 'Show the background of the notes tiles';

  @override
  String get settings_show_separators => 'Separators';

  @override
  String get settings_show_separators_description => 'Show a separator between the notes tiles';

  @override
  String get settings_behavior => 'Davranış';

  @override
  String get settings_behavior_description => 'Confirmations, swipe actions';

  @override
  String get settings_behavior_application => 'Application';

  @override
  String get settings_confirmations => 'Confirmation dialogs';

  @override
  String get settings_confirmations_description =>
      'Show the confirmation dialogs for actions such as pining and deleting notes';

  @override
  String get settings_flag_secure => 'Flag the app as secure';

  @override
  String get settings_flag_secure_description =>
      'Hide the app from the recent apps and prevent screenshots from being made';

  @override
  String get settings_behavior_swipe_actions => 'Swipe actions';

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
  String get settings_editor => 'Editor';

  @override
  String get settings_editor_description => 'Buttons, toolbar, spacing';

  @override
  String get settings_editor_formatting => 'Formatting';

  @override
  String get settings_editor_behavior => 'Behavior';

  @override
  String get settings_editor_appearance => 'Appearance';

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
  String get settings_show_editor_mode_button => 'Editor mode button';

  @override
  String get settings_show_editor_mode_button_description =>
      'Enable the button to toggle the editor between editing mode and viewing mode';

  @override
  String get settings_open_editor_reading_mode => 'Open in reading mode';

  @override
  String get settings_open_editor_reading_mode_description => 'Open the editor in reading mode by default';

  @override
  String get settings_focus_title_on_new_note => 'Focus the title';

  @override
  String get settings_focus_title_on_new_note_description =>
      'Focus the title instead of the content when creating a new note';

  @override
  String get settings_use_paragraph_spacing => 'Paragraph spacing';

  @override
  String get settings_use_paragraph_spacing_description => 'Use spacing between paragraphs';

  @override
  String get settings_backup => 'Yedekleme';

  @override
  String get settings_backup_description => 'Export, import';

  @override
  String get settings_backup_auto_export => 'Automatic export';

  @override
  String get settings_backup_manual_export => 'Manual export';

  @override
  String get settings_backup_import => 'Import';

  @override
  String get settings_import => 'İçe aktar';

  @override
  String get settings_import_description => 'JSON dosyasından içe aktar';

  @override
  String get settings_import_success => 'İçe aktarma başarılı.';

  @override
  String get settings_auto_export => 'Automatic export';

  @override
  String get settings_auto_export_description =>
      'Automatically export the notes to a JSON file (bin included) that can be imported back';

  @override
  String get settings_auto_export_frequency => 'Frequency';

  @override
  String settings_auto_export_frequency_value(String frequency) {
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
  String get settings_auto_export_frequency_description => 'Frequency of the automatic export of the notes';

  @override
  String get settings_auto_export_encryption => 'Encryption';

  @override
  String get settings_auto_export_encryption_description =>
      'Encrypt the title and the content of the notes with a password';

  @override
  String get settings_auto_export_directory => 'Directory';

  @override
  String get settings_auto_export_directory_description =>
      'Directory where to store the automatic exports of the notes';

  @override
  String get settings_export_success => 'Dışa aktarma başarılı';

  @override
  String get settings_export_json => 'JSON olarak dışa aktar';

  @override
  String get settings_export_json_description =>
      'Immediately export the notes to a JSON file (bin included) that can be imported back';

  @override
  String get settings_export_markdown => 'Markdown olarak dışa aktar';

  @override
  String get settings_export_markdown_description => 'Immediately export the notes to a Markdown file (bin included)';

  @override
  String get settings_about => 'Hakkında';

  @override
  String get settings_about_description => 'Information, help, GitHub, license';

  @override
  String get settings_about_application => 'Application';

  @override
  String get settings_about_links => 'Links';

  @override
  String get settings_about_help => 'Help';

  @override
  String get settings_build_mode => 'Build mode';

  @override
  String get settings_build_mode_release => 'Release';

  @override
  String get settings_build_mode_debug => 'Debug';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Kaynak koduna göz at';

  @override
  String get settings_localizations => 'Crowdin';

  @override
  String get settings_localizations_description => 'Add or improve the localizations on the Crowdin project';

  @override
  String get settings_licence => 'Lisans';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get settings_github_issues => 'Report a bug or request a feature';

  @override
  String get settings_github_issues_description => 'Report a bug or request a feature by creating a GitHub issue';

  @override
  String get settings_github_discussions => 'Ask a question';

  @override
  String get settings_github_discussions_description => 'Ask a question on GitHub discussions';

  @override
  String get settings_get_in_touch => 'Contact the developer';

  @override
  String settings_get_in_touch_description(Object email) {
    return 'Contact the developer via mail at $email';
  }

  @override
  String get hint_title => 'Başlık';

  @override
  String get hint_note => 'Note';

  @override
  String get tooltip_fab_add_note => 'Bir not ekle';

  @override
  String get tooltip_fab_empty_bin => 'Çöp kutusunu boşalt';

  @override
  String get tooltip_fab_toggle_editor_mode_edit => 'Switch to editing mode';

  @override
  String get tooltip_fab_toggle_editor_mode_read => 'Switch to reading mode';

  @override
  String get tooltip_layout_list => 'List view';

  @override
  String get tooltip_layout_grid => 'Grid view';

  @override
  String get tooltip_sort => 'Notları sırala';

  @override
  String get tooltip_search => 'Notların içinde ara';

  @override
  String get tooltip_toggle_checkbox => 'Onay kutusunu aç/kapat';

  @override
  String get tooltip_select_all => 'Tümünü seç';

  @override
  String get tooltip_unselect_all => 'Tümünün seçimini kaldır';

  @override
  String get tooltip_delete => 'Sil';

  @override
  String get tooltip_permanently_delete => 'Kalıcı sil';

  @override
  String get tooltip_restore => 'Kurtar';

  @override
  String get tooltip_toggle_pins => 'Sabitlemeyi aç/kapat';

  @override
  String get tooltip_reset => 'Reset';

  @override
  String get dialog_add_link => 'Add a link';

  @override
  String get dialog_link => 'Link';

  @override
  String get dialog_delete => 'Sil';

  @override
  String dialog_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notu',
      one: 'notu',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'onları',
      one: 'onu',
      zero: '',
    );
    return 'Gerçekten $count $_temp0 silmek istiyor musunuz? Çöp kutusundan $_temp1 kurtarabilirsiniz.';
  }

  @override
  String get dialog_delete_body_single => 'Bu notu gerçekten silmek istiyor musunuz?Çöp kutusundan kurtarabilirsiniz.';

  @override
  String get dialog_permanently_delete => 'Kalıcı sil';

  @override
  String dialog_permanently_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notu',
      one: 'notu',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Onları',
      one: 'Onu',
      zero: '',
    );
    return 'Gerçekten $count $_temp0 kalıcı olarak silmek istiyor musunuz?$_temp1 kurtaramazsınız.';
  }

  @override
  String get dialog_permanently_delete_body_single =>
      'Bu notu gerçekten kalıcı olarak silmek istiyor musunuz?Kurtarmanız mümkün olmayacaktır.';

  @override
  String get dialog_restore => 'Kurtar';

  @override
  String dialog_restore_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notu',
      one: 'notu',
      zero: '',
    );
    return 'Gerçekten $count $_temp0 kurtarmak istiyor musunuz?';
  }

  @override
  String get dialog_restore_body_single => 'Bu notu gerçekten kurtarmak istiyor musunuz?';

  @override
  String get dialog_empty_bin => 'Çöp kutusunu boşalt';

  @override
  String get dialog_empty_bin_body =>
      'Çöp kutusunu gerçekten kalıcı olarak boşaltmak istiyor musunuz? İçerdiği notları kurtaramazsınız';

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
  String get sort_date => 'Tarih';

  @override
  String get sort_title => 'Başlık';

  @override
  String get sort_ascending => 'Artan';

  @override
  String get placeholder_notes => 'Not yok';

  @override
  String get placeholder_bin => 'No deleted notes';

  @override
  String get action_disabled => 'Disabled';

  @override
  String get action_pin => 'Pin';

  @override
  String get action_unpin => 'Unpin';

  @override
  String get action_copy => 'Copy';

  @override
  String get action_share => 'Share';

  @override
  String get action_delete => 'Delete';

  @override
  String get action_restore => 'Restore';

  @override
  String get action_delete_permanently => 'Delete permanently';

  @override
  String get action_about => 'About';

  @override
  String get confirmations_title_none => 'Asla';

  @override
  String get confirmations_title_irreversible => 'Sadece geri alınamaz eylemler';

  @override
  String get confirmations_title_all => 'Her zaman';

  @override
  String get about_last_edited => 'Son düzenleme';

  @override
  String get about_created => 'Oluşturma tarihi';

  @override
  String get about_words => 'Kelime';

  @override
  String get about_characters => 'Karakter';

  @override
  String get snack_bar_copied => 'Content of the note copied to the clipboard.';

  @override
  String get action_add_note_title => 'Not ekle';

  @override
  String get welcome_note_title => 'Material Notes\'a hoşgeldin!';

  @override
  String get welcome_note_content => 'Basit, çevrimdışı, materyal tasarımlı notlar';

  @override
  String get time_at => 'saat';
}
