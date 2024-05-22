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
  String get navigation_notes => 'Notlar';

  @override
  String get navigation_bin => 'Çöp Kutusu';

  @override
  String get navigation_settings => 'Ayarlar';

  @override
  String get error_error => 'Hata';

  @override
  String get error_permission => 'Dosyayı yazma izni alınamadı.';

  @override
  String get error_read_file => 'Dosyayı okuma izni alınamadı.';

  @override
  String get settings_appearance => 'Görünüş';

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
  String get settings_editor => 'Editor';

  @override
  String get settings_show_undo_redo_buttons => 'Undo/redo buttons';

  @override
  String get settings_show_undo_redo_buttons_description => 'Show the buttons to undo and redo changes in the editor';

  @override
  String get settings_show_checklist_button => 'Checklist button';

  @override
  String get settings_show_checklist_button_description => 'Show the button to toggle checklists in the editor';

  @override
  String get settings_show_toolbar => 'Editor toolbar';

  @override
  String get settings_show_toolbar_description => 'Show the editor toolbar to enable advanced text formatting';

  @override
  String get settings_show_separators => 'Ayırıcıları göster';

  @override
  String get settings_show_separators_description => 'Notları kolayca ayırt etmek için aralarında bir ayırıcı gösterin';

  @override
  String get settings_behavior => 'Davranış';

  @override
  String get settings_confirmations => 'Onay diyaloglarını göster';

  @override
  String get settings_backup => 'Yedekleme';

  @override
  String get settings_export_json => 'JSON olarak dışa aktar';

  @override
  String get settings_export_markdown => 'Markdown olarak dışa aktar';

  @override
  String get settings_export_json_description =>
      'Notları daha sonra kurtarabilmek için bir JSON dosyasına (çöp kutusu dahil) aktarın';

  @override
  String get settings_export_markdown_description =>
      'Notları daha sonra kurtarabilmek için bir markdown dosyasına (çöp kutusu dahil) aktarın';

  @override
  String get settings_export_success => 'Dışa aktarma başarılı';

  @override
  String get settings_import => 'İçe aktar';

  @override
  String get settings_import_description => 'JSON dosyasından içe aktar';

  @override
  String get settings_import_success => 'İçe aktarma başarılı.';

  @override
  String get settings_about => 'Hakkında';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Kaynak koduna göz at';

  @override
  String get settings_licence => 'Lisans';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get settings_issue => 'Hata bildir';

  @override
  String get settings_issue_description => 'GitHub\'da bir issue oluşturarak bir hata bildirin';

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
  String get button_ok => 'Tamam';

  @override
  String get button_close => 'Kapat';

  @override
  String get button_cancel => 'İptal et';

  @override
  String get button_add => 'Ekle';

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
  String get dismiss_pin => 'Sabitle';

  @override
  String get dismiss_unpin => 'Sabitleme';

  @override
  String get dismiss_delete => 'Sil';

  @override
  String get dismiss_permanently_delete => 'Kalıcı sil';

  @override
  String get dismiss_restore => 'Kurtar';

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
}
