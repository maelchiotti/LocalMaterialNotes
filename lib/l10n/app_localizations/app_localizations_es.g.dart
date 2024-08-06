import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get app_tagline => 'Notas simples, locales, en Material Design';

  @override
  String app_about(Object appName) {
    return '$appName es una aplicación de toma de notas basadas en texto, orientada a la simplicidad, diseñada adoptando Material Design. $appName almacena las notas localmente y no requiere ningún permiso de internet, siendo tú el único que puede acceder a las notas.';
  }

  @override
  String get error_error => 'Error';

  @override
  String get error_permission => 'Fallo al obtener permisos para guardar el archivo.';

  @override
  String get error_read_file => 'Fallo al leer el archivo.';

  @override
  String get navigation_notes => 'Notas';

  @override
  String get navigation_bin => 'Papelera';

  @override
  String get navigation_settings => 'Ajustes';

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
  String get button_ok => 'Aceptar';

  @override
  String get button_close => 'Cerrar';

  @override
  String get button_cancel => 'Cancelar';

  @override
  String get button_add => 'Agregar';

  @override
  String get settings_appearance => 'Apariencia';

  @override
  String get settings_appearance_description => 'Language, theme, notes tiles';

  @override
  String get settings_appearance_application => 'Application';

  @override
  String get settings_appearance_notes_tiles => 'Notes tiles';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_theme => 'Tema';

  @override
  String get settings_theme_system => 'Sistema';

  @override
  String get settings_theme_light => 'Claro';

  @override
  String get settings_theme_dark => 'Oscuro';

  @override
  String get settings_dynamic_theming => 'Tema dinámico';

  @override
  String get settings_dynamic_theming_description => 'Generate colors from the system';

  @override
  String get settings_black_theming => 'Negro puro';

  @override
  String get settings_black_theming_description => 'Fondo negro puro para el tema oscuro';

  @override
  String get settings_show_separators => 'Separators';

  @override
  String get settings_show_separators_description =>
      'Show a separator between the notes tiles to differentiate them easily';

  @override
  String get settings_show_tiles_background => 'Background';

  @override
  String get settings_show_tiles_background_description =>
      'Show the background of the notes tiles to differentiate them easily';

  @override
  String get settings_behavior => 'Comportamiento';

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
  String get settings_show_undo_redo_buttons => 'Botones deshacer/rehacer';

  @override
  String get settings_show_undo_redo_buttons_description =>
      'Show the buttons to undo and redo changes in the editor\'s app bar';

  @override
  String get settings_show_checklist_button => 'Botón de casilla de verificación';

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
  String get settings_backup => 'Respaldo';

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
  String get settings_export_success => 'Las notas fueron exportadas exitosamente.';

  @override
  String get settings_export_json => 'Exportar a JSON';

  @override
  String get settings_export_json_description =>
      'Immediately export the notes to a JSON file (bin included) that can be imported back';

  @override
  String get settings_export_markdown => 'Exportar a Markdown';

  @override
  String get settings_export_markdown_description => 'Immediately export the notes to a Markdown file (bin included)';

  @override
  String get settings_import => 'Importar';

  @override
  String get settings_import_description => 'Importar notas desde un archivo JSON';

  @override
  String get settings_import_success => 'Las notas fueron importadas exitosamente.';

  @override
  String get settings_about => 'Acerca de';

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
  String get settings_github_description => 'Da un vistazo al código fuente';

  @override
  String get settings_licence => 'Licencia';

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
  String get hint_title => 'Título';

  @override
  String get hint_note => 'Nota';

  @override
  String get tooltip_fab_add_note => 'Agregar una nota';

  @override
  String get tooltip_fab_empty_bin => 'Vaciar la papelera';

  @override
  String get tooltip_layout_list => 'Vista en lista';

  @override
  String get tooltip_layout_grid => 'Vista en cuadrícula';

  @override
  String get tooltip_sort => 'Ordenar las notas';

  @override
  String get tooltip_search => 'Buscar entre las notas';

  @override
  String get tooltip_toggle_checkbox => 'Alternar casilla';

  @override
  String get tooltip_select_all => 'Seleccionar todo';

  @override
  String get tooltip_unselect_all => 'Deseleccionar todo';

  @override
  String get tooltip_delete => 'Eliminar';

  @override
  String get tooltip_permanently_delete => 'Eliminar permanentemente';

  @override
  String get tooltip_restore => 'Restaurar';

  @override
  String get tooltip_toggle_pins => 'Alternar fijado';

  @override
  String get dialog_delete => 'Eliminar';

  @override
  String dialog_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notas',
      one: 'nota',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'las',
      one: 'la',
      zero: '',
    );
    return '¿Realmente quieres eliminar $count $_temp0? Puedes restaurar$_temp1 desde la papelera.';
  }

  @override
  String get dialog_delete_body_single =>
      '¿Realmente quierers eliminar esta nota? Puedes restaurarla desde la papelera.';

  @override
  String get dialog_permanently_delete => 'Eliminar permanentemente';

  @override
  String dialog_permanently_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notas',
      one: 'nota',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'las',
      one: 'la',
      zero: '',
    );
    return '¿Realmente quieres eliminar permanentemente $count $_temp0? No podrás restaurar$_temp1.';
  }

  @override
  String get dialog_permanently_delete_body_single =>
      '¿Realmente quieres eliminar permanentemente esta nota? No podrás restaurarla.';

  @override
  String get dialog_restore => 'Restaurar';

  @override
  String dialog_restore_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notas',
      one: 'nota',
      zero: '',
    );
    return '¿Realmente quieres restaurar $count $_temp0?';
  }

  @override
  String get dialog_restore_body_single => '¿Realmente quieres restaurar esta nota?';

  @override
  String get dialog_empty_bin => 'Vaciar la papelera';

  @override
  String get dialog_empty_bin_body =>
      '¿Realmente quieres restaurar la papelera? No podrás restaurar las notas en ella.';

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
  String get sort_date => 'Fecha';

  @override
  String get sort_title => 'Título';

  @override
  String get sort_ascending => 'Ascendente';

  @override
  String get placeholder_notes => 'No hay notas';

  @override
  String get placeholder_bin => 'No deleted notes';

  @override
  String get menu_pin => 'Fijar';

  @override
  String get menu_share => 'Compartir';

  @override
  String get menu_unpin => 'Desfijar';

  @override
  String get menu_delete => 'Eliminar';

  @override
  String get menu_restore => 'Restaurar';

  @override
  String get menu_delete_permanently => 'Eliminar permanentemente';

  @override
  String get menu_about => 'Acerca de';

  @override
  String get confirmations_title_none => 'Nunca';

  @override
  String get confirmations_title_irreversible => 'Sólo acciones irreversibles';

  @override
  String get confirmations_title_all => 'Siempre';

  @override
  String get swipe_action_disabled => 'Disabled';

  @override
  String get swipe_action_delete => 'Delete';

  @override
  String get swipe_action_pin => 'Pin';

  @override
  String get dismiss_pin => 'Fijar';

  @override
  String get dismiss_unpin => 'Desfijar';

  @override
  String get dismiss_delete => 'Eliminar';

  @override
  String get about_last_edited => 'Última edición';

  @override
  String get about_created => 'Creación';

  @override
  String get about_words => 'Palabras';

  @override
  String get about_characters => 'Caracteres';

  @override
  String get time_at => 'el';

  @override
  String get action_add_note_title => 'Agregar una nota';

  @override
  String get welcome_note_title => 'Bienvenido a Material Notes !';

  @override
  String get welcome_note_content => 'Notas simples, locales, en Material Design';
}
