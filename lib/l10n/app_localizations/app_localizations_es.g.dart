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
  String get navigation_notes => 'Notas';

  @override
  String get navigation_bin => 'Papelera';

  @override
  String get navigation_settings => 'Ajustes';

  @override
  String get error_error => 'Error';

  @override
  String get error_permission => 'Fallo al obtener permisos para guardar el archivo.';

  @override
  String get error_read_file => 'Fallo al leer el archivo.';

  @override
  String get settings_appearance => 'Apariencia';

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
  String get settings_dynamic_theming_description => 'Generar colores a partir del sistema';

  @override
  String get settings_black_theming => 'Negro puro';

  @override
  String get settings_black_theming_description => 'Fondo negro puro para el tema oscuro';

  @override
  String get settings_editor => 'Editor';

  @override
  String get settings_show_undo_redo_buttons => 'Botones deshacer/rehacer';

  @override
  String get settings_show_undo_redo_buttons_description =>
      'Mostrar los botones para deshacer y rehacer cambios en el editor';

  @override
  String get settings_show_checklist_button => 'Botón de casilla de verificación';

  @override
  String get settings_show_checklist_button_description =>
      'Mostrar el botón para alternar casillas de verificación en el editor';

  @override
  String get settings_show_toolbar => 'Barra de herramientas del editor';

  @override
  String get settings_show_toolbar_description =>
      'Mostrar la barra de herramientas del editor para habilitar el formateado avanzado del texto.';

  @override
  String get settings_show_separators => 'Mostrar separadores';

  @override
  String get settings_show_separators_description => 'Mostrar un separador entre notas para diferenciarlas fácilmente';

  @override
  String get settings_show_tiles_background => 'Show the tiles background';

  @override
  String get settings_show_tiles_background_description =>
      'Show the background of the notes tiles to differentiate them easily';

  @override
  String get settings_behavior => 'Comportamiento';

  @override
  String get settings_confirmations => 'Mostrar diálogos de confirmación';

  @override
  String get settings_confirmations_description =>
      'Show the confirmation dialogs for actions such as pining and deleting notes';

  @override
  String get settings_flag_secure => 'Set the app as secure';

  @override
  String get settings_flag_secure_description =>
      'Hide the app from the recent apps and prevent screenshots from being made.';

  @override
  String get settings_backup => 'Respaldo';

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
      'Exportar notas a un archivo JSON (incluyendo la papelera) que pueda ser importado de vuelta';

  @override
  String get settings_export_markdown => 'Exportar a Markdown';

  @override
  String get settings_export_markdown_description => 'Exportar notas a un archivo Markdown (incluyendo la papelera)';

  @override
  String get settings_import => 'Importar';

  @override
  String get settings_import_description => 'Importar notas desde un archivo JSON';

  @override
  String get settings_import_success => 'Las notas fueron importadas exitosamente.';

  @override
  String get settings_import_incompatible_prior_v1_5_0 =>
      'Exports made in versions prior to v1.5.0 are not compatible anymore. Please see the pinned issue on GitHub for an easy fix.';

  @override
  String get settings_about => 'Acerca de';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Da un vistazo al código fuente';

  @override
  String get settings_licence => 'Licencia';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get settings_issue => 'Reportar un bug';

  @override
  String get settings_issue_description => 'Reportar un bug creando un issue en GitHub';

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
  String get button_ok => 'Aceptar';

  @override
  String get button_close => 'Cerrar';

  @override
  String get button_cancel => 'Cancelar';

  @override
  String get button_add => 'Agregar';

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
  String get sort_date => 'Fecha';

  @override
  String get sort_title => 'Título';

  @override
  String get sort_ascending => 'Ascendente';

  @override
  String get placeholder_notes => 'No hay notas';

  @override
  String get placeholder_bin => 'La papelera está vacía';

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
  String get dismiss_pin => 'Fijar';

  @override
  String get dismiss_unpin => 'Desfijar';

  @override
  String get dismiss_delete => 'Eliminar';

  @override
  String get dismiss_permanently_delete => 'Eliminar permanentemente';

  @override
  String get dismiss_restore => 'Restaurar';

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
}
