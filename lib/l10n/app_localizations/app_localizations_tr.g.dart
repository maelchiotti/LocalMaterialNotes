import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get app_name => 'Material Not';

  @override
  String get app_tagline => 'Basit, çevrimdışı, materyal tasarımlı notlar';

  @override
  String app_about(String appName) {
    return '$appName basitliği hedefleyen metin tabanlı bir not alma uygulamasıdır. Materyal Tasarımı benimser. Notları yerel olarak saklar ve internet izni yoktur, böylece notlara erişebilen tek kişi sizsiniz.';
  }

  @override
  String get error_snack_bar => 'Hata:';

  @override
  String get error_widget_title => 'Bir hata oluştu.';

  @override
  String get error_widget_description =>
      'Lütfen bu sorunu GitHub\'da veya posta yoluyla bildirin. Bu sayfanın bir ekran görüntüsünü ve kopyalayabileceğiniz veya dışa aktarabileceğiniz günlükleri aşağıya ekleyin. Önlem olarak, notlarınızı da dışa aktarmalısınız.';

  @override
  String get error_widget_disabled_secure_flag =>
      'Uygulamayı güvenli olarak işaretleme ayarı, ekran görüntülerini etkinleştirmek için bir sonraki yeniden başlatmaya kadar devre dışı bırakılır.';

  @override
  String get error_widget_button_export_notes => 'Notları dışarı aktar';

  @override
  String get error_widget_button_copy_logs => 'Günlükleri kopyala';

  @override
  String get error_widget_button_export_logs => 'Günlüğü indir';

  @override
  String get error_widget_button_create_github_issue => 'GitHub sorunu ekle';

  @override
  String get error_widget_button_send_mail => 'Posta gönder';

  @override
  String get navigation_notes => 'Notlar';

  @override
  String get navigation_bin => 'Çöp Kutusu';

  @override
  String get navigation_settings => 'Ayarlar';

  @override
  String get navigation_settings_appearance => 'Görünüm';

  @override
  String get navigation_settings_behavior => 'Davranış';

  @override
  String get navigation_settings_editor => 'Düzenleyici';

  @override
  String get navigation_settings_backup => 'Yedekle';

  @override
  String get navigation_settings_about => 'Hakkında';

  @override
  String get button_sort_title => 'Başlık';

  @override
  String get button_sort_ascending => 'Artan';

  @override
  String get settings_appearance => 'Görünüş';

  @override
  String get settings_appearance_description => 'Dil, tema, metin ölçeklendirme, not kutucukları';

  @override
  String get settings_appearance_application => 'Uygulama';

  @override
  String get settings_language => 'Dil';

  @override
  String get settings_language_contribute => 'Bağış yap';

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
  String get settings_text_scaling => 'Metin Ölçekleme';

  @override
  String get settings_appearance_notes_tiles => 'Metin karo';

  @override
  String get settings_show_titles_only => 'Sadece başlıklar';

  @override
  String get settings_show_titles_only_description => 'Yalnızca notların başlıklarını gösterin';

  @override
  String get settings_show_titles_only_disable_in_search_view =>
      'Başlıkları yalnızca arama görünümünde devre dışı bırak';

  @override
  String get settings_show_titles_only_disable_in_search_view_description =>
      'Arama görünümündeyken yalnızca başlıkları gösterme seçeneğini devre dışı bırakın';

  @override
  String get settings_disable_subdued_note_content_preview => 'Bastırılmamış önizleme';

  @override
  String get settings_disable_subdued_note_content_preview_description =>
      'Not içeriği önizlemesinin bastırılmış metin rengini devre dışı bırakma';

  @override
  String get settings_show_tiles_background => 'Arkaplan';

  @override
  String get settings_show_tiles_background_description => 'Not karolarının arka planını gösterin';

  @override
  String get settings_show_separators => 'Ayırıcı';

  @override
  String get settings_show_separators_description => 'Not kutucukları arasında bir ayırıcı göster';

  @override
  String get settings_behavior => 'Davranış';

  @override
  String get settings_behavior_description => 'Onaylar, güvenli bayrak, kaydırma eylemleri';

  @override
  String get settings_behavior_application => 'Uygulama';

  @override
  String get settings_confirmations => 'Onay iletişim kutuları';

  @override
  String get settings_confirmations_description =>
      'Not üzerinde bir eylem gerçekleştirirken bir onay iletişim kutusu ne zaman gösterilir';

  @override
  String get settings_confirmations_title_none => 'Asla';

  @override
  String get settings_confirmations_title_irreversible => 'Sadece geri alınamaz eylemler';

  @override
  String get settings_confirmations_title_all => 'Her zaman';

  @override
  String get settings_flag_secure => 'Uygulamayı güvenli olarak işaretleyin';

  @override
  String get settings_flag_secure_description =>
      'Uygulamayı son uygulamalardan gizleyin ve ekran görüntüsü alınmasını engelleyin';

  @override
  String get settings_behavior_swipe_actions => 'Kaydırma işlemleri';

  @override
  String get settings_swipe_action_right => 'Sağa kaydırma eylemi';

  @override
  String get settings_swipe_action_right_description =>
      'Bir not kutucuğu üzerinde sağa kaydırma yapıldığında tetiklenecek eylem';

  @override
  String get settings_swipe_action_left => 'Sola kaydırma eylemi';

  @override
  String get settings_swipe_action_left_description =>
      'Bir not kutucuğu üzerinde sola kaydırma yapıldığında tetiklenecek eylem';

  @override
  String get settings_editor => 'Düzenleyen';

  @override
  String get settings_editor_description => 'Düğmeler, araç çubuğu, okuma modu, aralık';

  @override
  String get settings_editor_formatting => 'Biçimlendirme';

  @override
  String get settings_show_undo_redo_buttons => 'Geri al/yinele düğmeleri';

  @override
  String get settings_show_undo_redo_buttons_description =>
      'Düzenleyicinin uygulama çubuğunda değişiklikleri geri almak ve yinelemek için düğmeleri gösterin';

  @override
  String get settings_show_checklist_button => 'Kontrol listesi tuşları';

  @override
  String get settings_show_checklist_button_description =>
      'Kontrol listelerini düzenleyicinin uygulama çubuğunda değiştirmek için düğmeyi gösterin, etkinleştirilmişse düzenleyicinin araç çubuğundan gizleyin';

  @override
  String get settings_show_toolbar => 'Araç çubuğu';

  @override
  String get settings_show_toolbar_description =>
      'Gelişmiş metin biçimlendirmesini etkinleştirmek için düzenleyicinin araç çubuğunu gösterin';

  @override
  String get settings_editor_behavior => 'Davranış';

  @override
  String get settings_show_editor_mode_button => 'Düzenleyici modu düğmesi';

  @override
  String get settings_show_editor_mode_button_description =>
      'Düzenleyiciyi düzenleme modu ile okuma modu arasında değiştirmek için düğmeyi etkinleştirin';

  @override
  String get settings_open_editor_reading_mode => 'Okuma modunda açın';

  @override
  String get settings_open_editor_reading_mode_description => 'Düzenleyiciyi varsayılan olarak okuma modunda açın';

  @override
  String get settings_focus_title_on_new_note => 'Başlığa odaklanın';

  @override
  String get settings_focus_title_on_new_note_description =>
      'Yeni bir not oluştururken içerik yerine başlığa odaklanın';

  @override
  String get settings_editor_appearance => 'Görünüm';

  @override
  String get settings_use_paragraph_spacing => 'Paragraf aralığı';

  @override
  String get settings_use_paragraph_spacing_description => 'Paragraflar arasında boşluk kullanın';

  @override
  String get settings_backup => 'Yedekleme';

  @override
  String get settings_backup_description => 'Manuel ve otomatik dışa aktarma, şifreleme, içe aktarma';

  @override
  String get settings_backup_import => 'İçe aktar';

  @override
  String get settings_import => 'İçe aktar';

  @override
  String get settings_import_description => 'JSON dosyasından içe aktar';

  @override
  String get settings_backup_manual_export => 'Manuel dışa aktarma';

  @override
  String get settings_export_json => 'JSON olarak dışa aktar';

  @override
  String get settings_export_json_description =>
      'Notları hemen geri alınabilecek bir JSON dosyasına (bin dahil) aktarın';

  @override
  String get settings_export_markdown => 'Markdown olarak dışa aktar';

  @override
  String get settings_export_markdown_description => 'Notları hemen bir Markdown dosyasına aktarın (bin dahil)';

  @override
  String get settings_backup_auto_export => 'Otomatik dışa aktarma';

  @override
  String get settings_auto_export => 'Otomatik dışa aktarma';

  @override
  String get settings_auto_export_description =>
      'Notları hemen geri alınabilecek bir JSON dosyasına (bin dahil) aktarın';

  @override
  String get settings_auto_export_frequency => 'Sıklık';

  @override
  String settings_auto_export_frequency_value(String frequency) {
    String _temp0 = intl.Intl.selectLogic(
      frequency,
      {
        '1': 'gün',
        '7': 'hafta',
        '14': '2 haftalar',
        '30': 'ay',
        'other': '$frequency aylar',
      },
    );
    return 'Her $_temp0';
  }

  @override
  String get settings_auto_export_frequency_description => 'Notların otomatik olarak dışa aktarılma sıklığı';

  @override
  String get settings_auto_export_encryption => 'Şifreleme';

  @override
  String get settings_auto_export_encryption_description => 'Notların başlığını ve içeriğini bir parola ile şifreleyin';

  @override
  String get settings_auto_export_directory => 'Rehber';

  @override
  String get settings_auto_export_directory_description => 'Notların otomatik dışa aktarımlarının saklanacağı dizin';

  @override
  String get settings_about => 'Hakkında';

  @override
  String get settings_about_description => 'Bilgi, yardım, bağlantılar';

  @override
  String get settings_about_application => 'Uygulama';

  @override
  String get settings_build_mode => 'Yapı Modu';

  @override
  String get settings_build_mode_release => 'Kararlı';

  @override
  String get settings_build_mode_debug => 'Hata ayıklama';

  @override
  String get settings_about_help => 'Yardım';

  @override
  String get settings_github_issues => 'Bir hata bildirin veya bir özellik talep edin';

  @override
  String get settings_github_issues_description =>
      'Bir GitHub sorunu oluşturarak bir hata bildirin veya bir özellik talep edin';

  @override
  String get settings_github_discussions => 'Soru sor';

  @override
  String get settings_github_discussions_description => 'GitHub tartışmalarında soru sorun';

  @override
  String get settings_get_in_touch => 'Geliştirici ile iletişime geç';

  @override
  String settings_get_in_touch_description(Object email) {
    return 'Geliştiriciye $email adresinden posta yoluyla ulaşın';
  }

  @override
  String get settings_about_links => 'Bağlantılar';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Kaynak koduna göz at';

  @override
  String get settings_localizations => 'Crowdin';

  @override
  String get settings_localizations_description => 'Crowdin projesine yerelleştirmeler ekleyin veya geliştirin';

  @override
  String get settings_licence => 'Lisans';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get settings_about_logs => 'Logs';

  @override
  String get settings_copy_logs => 'Copy the logs';

  @override
  String get settings_copy_logs_description => 'Copy the logs of the application to the clipboard';

  @override
  String get settings_export_logs => 'Export the logs';

  @override
  String get settings_export_logs_description => 'Export the logs of the application to a text file';

  @override
  String get hint_title => 'Başlık';

  @override
  String get hint_note => 'Note';

  @override
  String get hint_link => 'Bağlantı';

  @override
  String get dialog_export_encryption_password => 'Parola';

  @override
  String get tooltip_toggle_checkbox => 'Onay kutusunu aç/kapat';

  @override
  String get tooltip_toggle_pins => 'Sabitlemeyi aç/kapat';

  @override
  String get tooltip_fab_add_note => 'Bir not ekle';

  @override
  String get tooltip_fab_empty_bin => 'Çöp kutusunu boşalt';

  @override
  String get tooltip_fab_toggle_editor_mode_edit => 'Düzenleme moduna geçme';

  @override
  String get tooltip_fab_toggle_editor_mode_read => 'Düzenleme moduna geçme';

  @override
  String get tooltip_layout_list => 'Liste görünümü';

  @override
  String get tooltip_layout_grid => 'Izgara görünümü';

  @override
  String get tooltip_sort => 'Notları sırala';

  @override
  String get tooltip_search => 'Notların içinde ara';

  @override
  String get tooltip_unselect_all => 'Tümünün seçimini kaldır';

  @override
  String get tooltip_delete => 'Sil';

  @override
  String get tooltip_permanently_delete => 'Kalıcı sil';

  @override
  String get tooltip_restore => 'Kurtar';

  @override
  String get tooltip_reset => 'Sıfırla';

  @override
  String get dialog_add_link => 'Bağlantı ekle';

  @override
  String get dialog_delete => 'Sil';

  @override
  String dialog_delete_body(int count) {
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
  String get dialog_permanently_delete => 'Kalıcı sil';

  @override
  String dialog_permanently_delete_body(int count) {
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
  String get dialog_restore => 'Kurtar';

  @override
  String dialog_restore_body(int count) {
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
  String get dialog_empty_bin => 'Çöp kutusunu boşalt';

  @override
  String get dialog_empty_bin_body =>
      'Çöp kutusunu gerçekten kalıcı olarak boşaltmak istiyor musunuz? İçerdiği notları kurtaramazsınız';

  @override
  String get dialog_export_encryption_switch => 'JSON dışa aktarımını şifreleyin';

  @override
  String get dialog_export_encryption_description =>
      'Notların başlığı ve içeriği şifreniz kullanılarak şifrelenecektir. Şifre rastgele oluşturulmalı, tam olarak 32 karakter uzunluğunda, güçlü (en az 1 küçük harf, 1 büyük harf, 1 sayı ve 1 özel karakter) olmalı ve güvenli bir şekilde saklanmalıdır.';

  @override
  String get dialog_export_encryption_secondary_description_auto =>
      'Bu şifre gelecekteki tüm otomatik dışa aktarmalar için kullanılacaktır.';

  @override
  String get dialog_export_encryption_secondary_description_manual =>
      'Bu şifre sadece bu dışa aktarım için kullanılacaktır.';

  @override
  String get dialog_export_encryption_password_invalid => 'Geçersiz';

  @override
  String get dialog_import_encryption_password_description =>
      'Bu dışa aktarım şifrelenmiştir. İçeri aktarmak için, şifrelemek için kullanılan şifreyi sağlamanız gerekir.';

  @override
  String get dialog_import_encryption_password_error =>
      'dışa aktarmanın şifresinin çözülmesi başarısız oldu. Lütfen dışa aktarımı şifrelemek için kullandığınız parolayla aynı parolayı girip girmediğinizi kontrol edin.';

  @override
  String get button_sort_date => 'Tarih';

  @override
  String get placeholder_notes => 'Not yok';

  @override
  String get placeholder_bin => 'Silinen not yok';

  @override
  String get action_disabled => 'Kapalı';

  @override
  String get action_pin => 'Sabitle';

  @override
  String get action_unpin => 'Sabitleme';

  @override
  String get action_share => 'Paylaş';

  @override
  String get action_delete => 'Sil';

  @override
  String get action_restore => 'Kurtar';

  @override
  String get action_delete_permanently => 'Kalıcı sil';

  @override
  String get action_about => 'Hakkında';

  @override
  String get about_last_edited => 'Son düzenleme';

  @override
  String get about_created => 'Oluşturma tarihi';

  @override
  String get about_words => 'Kelime';

  @override
  String get about_characters => 'Karakter';

  @override
  String get about_time_at => 'saat';

  @override
  String get snack_bar_copied => 'Panoya kopyalanan notun içeriği.';

  @override
  String get snack_bar_import_success => 'Notlar başarıyla içe aktarıldı.';

  @override
  String get snack_bar_export_success => 'Dışa aktarma başarılı.';

  @override
  String get snack_bar_logs_copied => 'Günlükler panonuza kopyalandı.';

  @override
  String get snack_bar_logs_exported => 'Günlükler başarıyla dışa aktarıldı.';

  @override
  String get action_add_note_title => 'Not ekle';

  @override
  String get welcome_note_title => 'Material Notes\'a hoşgeldin!';

  @override
  String get welcome_note_content => 'Basit, çevrimdışı, materyal tasarımlı notlar';
}
