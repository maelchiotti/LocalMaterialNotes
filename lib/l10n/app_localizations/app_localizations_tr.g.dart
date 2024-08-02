import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get app_tagline => 'Basit, çevrimdışı, materyal tasarımlı notlar';

  @override
  String app_about(Object appName) {
    return '$appName basitliği hedefleyen metin tabanlı bir not alma uygulamasıdır. Materyal Tasarımı benimser. Notları yerel olarak saklar ve internet izni yoktur, böylece notlara erişebilen tek kişi sizsiniz.';
  }

  @override
  String get error_error => 'Hata';

  @override
  String get error_permission => 'Dosyayı yazma izni alınamadı.';

  @override
  String get error_read_file => 'Dosyayı okuma izni alınamadı.';

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
  String get button_close => 'Kapat';

  @override
  String get button_cancel => 'İptal et';

  @override
  String get button_add => 'Ekle';

  @override
  String get settings_appearance => 'Görünüş';

  @override
  String get settings_appearance_description => 'Language, theme, notes tiles';

  @override
  String get settings_appearance_application => 'Application';

  @override
  String get settings_appearance_notes_tiles => 'Notes tiles';

  @override
  String get settings_language => 'Dil';

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
  String get settings_dynamic_theming_description => 'Sisteminizdeki rengi baz alın';

  @override
  String get settings_black_theming => 'Siyah tema';

  @override
  String get settings_black_theming_description => 'Koyu modda siyah arkaplan kullanın';

  @override
  String get settings_show_separators => 'Ayırıcıları göster';

  @override
  String get settings_show_separators_description => 'Notları kolayca ayırt etmek için aralarında bir ayırıcı gösterin';

  @override
  String get settings_show_tiles_background => 'Background';

  @override
  String get settings_show_tiles_background_description =>
      'Show the background of the notes tiles to differentiate them easily';

  @override
  String get settings_behavior => 'Davranış';

  @override
  String get settings_behavior_application => 'Application';

  @override
  String get settings_behavior_description => 'Confirmations, swipe actions';

  @override
  String get settings_behavior_swipe_actions => 'Swipe actions';

  @override
  String get settings_confirmations => 'Onay diyaloglarını göster';

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
  String get settings_flag_secure => 'Make app secure';

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
  String get settings_backup => 'Yedekleme';

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
  String get settings_export_success => 'Dışa aktarma başarılı';

  @override
  String get settings_export_json => 'JSON olarak dışa aktar';

  @override
  String get settings_export_json_description =>
      'Notları daha sonra kurtarabilmek için bir JSON dosyasına (çöp kutusu dahil) aktarın';

  @override
  String get settings_export_markdown => 'Markdown olarak dışa aktar';

  @override
  String get settings_export_markdown_description =>
      'Notları daha sonra kurtarabilmek için bir markdown dosyasına (çöp kutusu dahil) aktarın';

  @override
  String get settings_import => 'İçe aktar';

  @override
  String get settings_import_description => 'JSON dosyasından içe aktar';

  @override
  String get settings_import_success => 'İçe aktarma başarılı.';

  @override
  String get settings_import_incompatible_prior_v1_5_0 =>
      'Exports made in versions prior to v1.5.0 are not compatible anymore. Please see the pinned issue on GitHub for an easy fix.';

  @override
  String get settings_about => 'Hakkında';

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
  String get settings_github_description => 'Kaynak koduna göz at';

  @override
  String get settings_licence => 'Lisans';

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
  String get hint_title => 'Başlık';

  @override
  String get hint_note => 'Note';

  @override
  String get tooltip_fab_add_note => 'Bir not ekle';

  @override
  String get tooltip_fab_empty_bin => 'Çöp kutusunu boşalt';

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
  String get placeholder_bin => 'Çöp kutusu boş';

  @override
  String get menu_pin => 'Sabitle';

  @override
  String get menu_share => 'Paylaş';

  @override
  String get menu_unpin => 'Sabitleme';

  @override
  String get menu_delete => 'Sil';

  @override
  String get menu_restore => 'Kurtar';

  @override
  String get menu_delete_permanently => 'Kalıcı Sil';

  @override
  String get menu_about => 'Hakkında';

  @override
  String get confirmations_title_none => 'Asla';

  @override
  String get confirmations_title_irreversible => 'Sadece geri alınamaz eylemler';

  @override
  String get confirmations_title_all => 'Her zaman';

  @override
  String get swipe_action_disabled => 'Disabled';

  @override
  String get swipe_action_delete => 'Delete';

  @override
  String get swipe_action_pin => 'Pin';

  @override
  String get dismiss_pin => 'Sabitle';

  @override
  String get dismiss_unpin => 'Sabitleme';

  @override
  String get dismiss_delete => 'Sil';

  @override
  String get about_last_edited => 'Son düzenleme';

  @override
  String get about_created => 'Oluşturma tarihi';

  @override
  String get about_words => 'Kelime';

  @override
  String get about_characters => 'Karakter';

  @override
  String get time_at => 'saat';

  @override
  String get action_add_note_title => 'Not ekle';

  @override
  String get welcome_note_title => 'Material Notes\'a hoşgeldin!';

  @override
  String get welcome_note_content => 'Basit, çevrimdışı, materyal tasarımlı notlar';
}
