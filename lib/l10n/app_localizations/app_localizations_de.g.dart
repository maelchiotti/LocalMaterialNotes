import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get app_tagline => 'Einfache, lokale Notizen-App im Material-Design';

  @override
  String app_about(String appName) {
    return '$appName ist eine auf Einfachheit abzielende, auf getipptem Text basierende Notizen Anwendung im Material-Design. Sie speichert die Notizen lokal und benötigt keine Berechtigung zum Internetzugriff, so dass nur Sie als einziges Zugriff auf die Notizen haben.';
  }

  @override
  String get error_error => 'Fehler';

  @override
  String get navigation_notes => 'Notizen';

  @override
  String get navigation_bin => 'Papierkorb';

  @override
  String get navigation_settings => 'Einstellungen';

  @override
  String get navigation_settings_appearance => 'Aussehen';

  @override
  String get navigation_settings_behavior => 'Verhalten';

  @override
  String get navigation_settings_editor => 'Editor';

  @override
  String get navigation_settings_backup => 'Sicherheitskopie';

  @override
  String get navigation_settings_about => 'Über';

  @override
  String get button_ok => 'In Ordnung';

  @override
  String get button_cancel => 'Schließen';

  @override
  String get button_sort_title => 'Titel';

  @override
  String get button_sort_ascending => 'Aufsteigend';

  @override
  String get settings_appearance => 'Aussehen';

  @override
  String get settings_appearance_description => 'Erscheinung';

  @override
  String get settings_appearance_application => 'Anwendung';

  @override
  String get settings_language => 'Sprache';

  @override
  String get settings_language_contribute => 'Mitwirken';

  @override
  String get settings_theme => 'Gestaltung';

  @override
  String get settings_theme_system => 'System';

  @override
  String get settings_theme_light => 'Hell';

  @override
  String get settings_theme_dark => 'Dunkel';

  @override
  String get settings_dynamic_theming => 'Veränderliche Gestalt';

  @override
  String get settings_dynamic_theming_description => 'Übernehme die Farben vom System';

  @override
  String get settings_black_theming => 'Schwarze Gestaltung';

  @override
  String get settings_black_theming_description => 'Nutze einen schwarzen Hintergrund im dunklen Modus';

  @override
  String get settings_text_scaling => 'Textskalierung';

  @override
  String get settings_appearance_notes_tiles => 'Notizenfelder';

  @override
  String get settings_show_titles_only => 'Nur Titel';

  @override
  String get settings_show_titles_only_description => 'Nur Notiz Titel anzeigen';

  @override
  String get settings_show_titles_only_disable_in_search_view => 'Nur Titel in Suche deaktivieren';

  @override
  String get settings_show_titles_only_disable_in_search_view_description =>
      'Deaktivieren Sie die Option, nur Titel anzuzeigen, wenn sie sich in der Suchansicht befinden';

  @override
  String get settings_disable_subdued_note_content_preview => 'Ungedämpfte Notiz Vorschau';

  @override
  String get settings_disable_subdued_note_content_preview_description =>
      'Deaktiviere die gedämpfte Textfarbe der Notiz Vorschau';

  @override
  String get settings_show_tiles_background => 'Hintergrund';

  @override
  String get settings_show_tiles_background_description => 'Hintergrund der Notizkacheln anzeigen';

  @override
  String get settings_show_separators => 'Trennzeichen';

  @override
  String get settings_show_separators_description => 'Trennlinie zwischen den Notizkacheln anzeigen';

  @override
  String get settings_behavior => 'Verhalten';

  @override
  String get settings_behavior_description => 'Verhalten';

  @override
  String get settings_behavior_application => 'Anwendung';

  @override
  String get settings_confirmations => 'Bestätigungsdialog';

  @override
  String get settings_confirmations_description => 'Bestätigungsdialog bei Aktion';

  @override
  String get settings_confirmations_title_none => 'Niemals';

  @override
  String get settings_confirmations_title_irreversible => 'Nur unwiderrufliche Aktionen';

  @override
  String get settings_confirmations_title_all => 'Immer';

  @override
  String get settings_flag_secure => 'App als sicher markieren';

  @override
  String get settings_flag_secure_description =>
      'Verstecke die App in der kürzlich geöffnete Apps Übersicht und verhindere, dass Screenshots gemacht werden';

  @override
  String get settings_behavior_swipe_actions => 'Wischgesten';

  @override
  String get settings_swipe_action_right => 'Aktion für Rechtswischen';

  @override
  String get settings_swipe_action_right_description => 'Aktion bei Nach-Rechts-Wischen';

  @override
  String get settings_swipe_action_left => 'Aktion für Linkswischen';

  @override
  String get settings_swipe_action_left_description => 'Aktion bei Nach-Links-Wischen';

  @override
  String get settings_editor => 'Editor';

  @override
  String get settings_editor_description => 'Schaltflächen, Symbolleiste, Lesemodus';

  @override
  String get settings_editor_formatting => 'Formatierung';

  @override
  String get settings_show_undo_redo_buttons => 'Rückgängig/Wiederholen-Tasten';

  @override
  String get settings_show_undo_redo_buttons_description =>
      'Zeige Schaltflächen, um Änderungen rückgängig zu machen oder zu wiederholen';

  @override
  String get settings_show_checklist_button => 'Checklisten-Schaltfläche';

  @override
  String get settings_show_checklist_button_description =>
      'Zeigen Sie die Schaltfläche zum Umschalten von Checklisten in der App-Leiste des Editors an und verbergen Sie sie in der Symbolleiste des Editors, wenn sie aktiviert ist';

  @override
  String get settings_show_toolbar => 'Symbolleiste';

  @override
  String get settings_show_toolbar_description =>
      'Zeigen Sie die Symbolleiste des Editors an, um erweiterte Textformatierungen zu aktivieren';

  @override
  String get settings_editor_behavior => 'Verhalten';

  @override
  String get settings_show_editor_mode_button => 'Bearbeitungsmodus-Schaltfläche';

  @override
  String get settings_show_editor_mode_button_description =>
      'Schaltfläche anzeigen zum Umschalten zwischen Bearbeitungsmodus und Lesemodus';

  @override
  String get settings_open_editor_reading_mode => 'Im Lesemodus öffnen';

  @override
  String get settings_open_editor_reading_mode_description => 'Editor standardmäßig im Lesemodus öffnen';

  @override
  String get settings_focus_title_on_new_note => 'Titel fokussieren';

  @override
  String get settings_focus_title_on_new_note_description =>
      'Fokussiere den Titel anstelle des Inhalts beim Erstellen einer neuen Notiz';

  @override
  String get settings_editor_appearance => 'Aussehen';

  @override
  String get settings_use_paragraph_spacing => 'Absatzabstand';

  @override
  String get settings_use_paragraph_spacing_description => 'Verwende Abstand zwischen Absätzen';

  @override
  String get settings_backup => 'Sicherung';

  @override
  String get settings_backup_description => 'Manueller und automatischer Export, Verschlüsselung, Import';

  @override
  String get settings_backup_import => 'Import';

  @override
  String get settings_import => 'Import';

  @override
  String get settings_import_description => 'Importierte Notizen aus einer JSON Datei';

  @override
  String get settings_backup_manual_export => 'Manueller Export';

  @override
  String get settings_export_json => 'Exportiere als JSON';

  @override
  String get settings_export_json_description =>
      'Exportiere die Notizen (Papierkorb enthalten) sofort als JSON Datei die zurückimportiert werden kann';

  @override
  String get settings_export_markdown => 'Exportiere als Markdown';

  @override
  String get settings_export_markdown_description =>
      'Exportiere die Notizen (Papierkorb enthalten) sofort als Markdown Datei';

  @override
  String get settings_backup_auto_export => 'Automatischer Export';

  @override
  String get settings_auto_export => 'Automatischer Export';

  @override
  String get settings_auto_export_description =>
      'Exportiere die Notizen (Papierkorb beinhaltet) automatisch in einer JSON Datei die zurückimportiert werden kann';

  @override
  String get settings_auto_export_frequency => 'Häufigkeit';

  @override
  String settings_auto_export_frequency_value(String frequency) {
    String _temp0 = intl.Intl.selectLogic(
      frequency,
      {
        '1': 'Tag',
        '7': 'Woche',
        '14': '2 Wochen',
        '30': 'Monat',
        'other': '$frequency Tage',
      },
    );
    return 'Jeden $_temp0';
  }

  @override
  String get settings_auto_export_frequency_description => 'Häufigkeit des automatischen Exports der Notizen';

  @override
  String get settings_auto_export_encryption => 'Verschlüsselung';

  @override
  String get settings_auto_export_encryption_description =>
      'Verschlüssele den Titel und den Inhalt er Notizen mit einem Passwort';

  @override
  String get settings_auto_export_directory => 'Pfad';

  @override
  String get settings_auto_export_directory_description => 'Ort, wo automatische Exporte gespeichert werden';

  @override
  String get settings_about => 'Über';

  @override
  String get settings_about_description => 'Über';

  @override
  String get settings_about_application => 'Anwendung';

  @override
  String get settings_build_mode => 'Build Modus';

  @override
  String get settings_build_mode_release => 'Veröffentlichung';

  @override
  String get settings_build_mode_debug => 'Fehlerbehebung';

  @override
  String get settings_about_help => 'Hilfe';

  @override
  String get settings_github_issues => 'Melde einen Fehler oder frage eine Funktion an';

  @override
  String get settings_github_issues_description =>
      'Melde einen Fehler oder frage eine Funktion über ein GitHub Issue an';

  @override
  String get settings_github_discussions => 'Frage eine Frage';

  @override
  String get settings_github_discussions_description => 'Frage eine Frage in GitHub Diskussionen';

  @override
  String get settings_get_in_touch => 'Kontaktiere den Entwickler';

  @override
  String settings_get_in_touch_description(Object email) {
    return 'Kontaktiere den Entwickler über Mail an $email';
  }

  @override
  String get settings_about_links => 'Links';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Den Quellcode einsehen';

  @override
  String get settings_localizations => 'Crowdin';

  @override
  String get settings_localizations_description => 'Lokalisierungen im Crowdin-Projekt hinzufügen oder verbessern';

  @override
  String get settings_licence => 'Lizenz';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get hint_title => 'Titel';

  @override
  String get hint_note => 'Notiz';

  @override
  String get hint_link => 'Verknüpfung';

  @override
  String get dialog_export_encryption_password => 'Passwort';

  @override
  String get tooltip_toggle_checkbox => 'Checkbox umschalten';

  @override
  String get tooltip_toggle_pins => 'Anheften umschalten';

  @override
  String get tooltip_fab_add_note => 'Notiz hinzufügen';

  @override
  String get tooltip_fab_empty_bin => 'Papierkorb leeren';

  @override
  String get tooltip_fab_toggle_editor_mode_edit => 'In Bearbeitungsmodus wechseln';

  @override
  String get tooltip_fab_toggle_editor_mode_read => 'In Lesemodus wechseln';

  @override
  String get tooltip_layout_list => 'Listenansicht';

  @override
  String get tooltip_layout_grid => 'Tabellenansicht';

  @override
  String get tooltip_sort => 'Notizen sortieren';

  @override
  String get tooltip_search => 'Suche Notizen';

  @override
  String get tooltip_select_all => 'Alle auswählen';

  @override
  String get tooltip_unselect_all => 'Alle abwählen';

  @override
  String get tooltip_delete => 'Löschen';

  @override
  String get tooltip_permanently_delete => 'Dauerhaft löschen';

  @override
  String get tooltip_restore => 'Wiederherstellen';

  @override
  String get tooltip_reset => 'Zurücksetzen';

  @override
  String get dialog_add_link => 'Verknüpfung hinzufügen';

  @override
  String get dialog_delete => 'Löschen';

  @override
  String dialog_delete_body(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notizen',
      one: 'Notiz',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'diese',
      one: 'diese',
      zero: '',
    );
    return 'Willst du diese $count $_temp0 wirklich löschen? Du kannst $_temp1 aus dem Papierkorb wiederherstellen.';
  }

  @override
  String get dialog_permanently_delete => 'Dauerhaft löschen';

  @override
  String dialog_permanently_delete_body(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notizen',
      one: 'Notiz',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'diese',
      one: 'diese',
      zero: '',
    );
    return 'Willst du die $count$_temp0 dauerhaft löschen? Du kannst $_temp1 nicht wiederherstellen.';
  }

  @override
  String get dialog_restore => 'Wiederherstellen';

  @override
  String dialog_restore_body(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Notizen',
      one: 'Notiz',
      zero: '',
    );
    return 'Willst du diese $count$_temp0 wirklich wiederherstellen?';
  }

  @override
  String get dialog_empty_bin => 'Papierkorb leeren';

  @override
  String get dialog_empty_bin_body =>
      'Willst du den Papierkorb wirklich dauerhaft leeren? Du kannst die enthaltenen Notizen nicht wiederherstellen.';

  @override
  String get dialog_export_encryption_switch => 'Verschlüssele den JSON Export';

  @override
  String get dialog_export_encryption_description =>
      'Der Titel und der Inhalt der Notiz werden mit deinem Passwort verschlüsselt. Es sollte zufällig generiert, 32 Zeichen lang, stark (mindestens 1 Kleinbuchstabe, 1 Großbuchstabe, 1 Ziffer, 1 Sonderzeichen) und sicher gespeichert sein.';

  @override
  String get dialog_export_encryption_secondary_description_auto =>
      'Passwort, das für alle zukünftigen automatischen Exporte genutzt wird.';

  @override
  String get dialog_export_encryption_secondary_description_manual =>
      'Dieses Passwort wird nur für diesen Export verwendet.';

  @override
  String get dialog_export_encryption_password_invalid => 'Ungültig';

  @override
  String get dialog_import_encryption_password_description =>
      'Dieser Export ist verschlüsselt. Um ihn zu importieren, musst du das Passwort eingeben, das du zum Verschlüsseln verwendet hast.';

  @override
  String get dialog_import_encryption_password_error =>
      'Die Entschlüsselung des Exportes ist fehlgeschlagen. Bitte überprüfe, dass du das Passwort eingegeben hast, das du zum Verschlüsseln verwendet hast.';

  @override
  String get button_sort_date => 'Datum';

  @override
  String get placeholder_notes => 'Keine Notizen';

  @override
  String get placeholder_bin => 'Keine gelöschten Notizen';

  @override
  String get action_disabled => 'Aus';

  @override
  String get action_pin => 'Anheften';

  @override
  String get action_unpin => 'Loslösen';

  @override
  String get action_copy => 'Kopieren';

  @override
  String get action_share => 'Teilen';

  @override
  String get action_delete => 'Löschen';

  @override
  String get action_restore => 'Wiederherstellen';

  @override
  String get action_delete_permanently => 'Endgültig löschen';

  @override
  String get action_about => 'Über';

  @override
  String get about_last_edited => 'Zuletzt bearbeitet';

  @override
  String get about_created => 'Erstellt';

  @override
  String get about_words => 'Wörter';

  @override
  String get about_characters => 'Zeichen';

  @override
  String get about_time_at => 'um';

  @override
  String get snack_bar_copied => 'Inhalt der Notiz in die Zwischenablage kopiert.';

  @override
  String get snack_bar_import_success => 'Die Notizen wurden erfolgreich importiert.';

  @override
  String get snack_bar_export_success => 'Die Notizen wurden erfolgreich exportiert.';

  @override
  String get action_add_note_title => 'Notiz erstellen';

  @override
  String get welcome_note_title => 'Willkommen bei Material Notes!';

  @override
  String get welcome_note_content => 'Einfache, lokale, materiell designte Notizen';
}
