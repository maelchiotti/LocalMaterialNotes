import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get app_tagline => 'Notas simples, locales, en Material Design';

  @override
  String app_about(String appName) {
    return '$appName es una aplicación de toma de notas basadas en texto, orientada a la simplicidad, diseñada adoptando Material Design. $appName almacena las notas localmente y no requiere ningún permiso de internet, siendo tú el único que puede acceder a las notas.';
  }

  @override
  String get error_snack_bar => 'Error:';

  @override
  String get error_widget_title => 'An error has occurred.';

  @override
  String get error_widget_description =>
      'Please report this issue on GitHub or via mail. Attach a screenshot of this page and the logs that you can copy or export below. As a precaution, you should also export your notes.';

  @override
  String get error_widget_disabled_secure_flag =>
      'The setting to flag the app as secure is disabled until the next restart to enable screenshots.';

  @override
  String get error_widget_button_export_notes => 'Export notes';

  @override
  String get error_widget_button_copy_logs => 'Copy logs';

  @override
  String get error_widget_button_export_logs => 'Export logs';

  @override
  String get error_widget_button_create_github_issue => 'Create GitHub issue';

  @override
  String get error_widget_button_send_mail => 'Send mail';

  @override
  String get navigation_notes => 'Notas';

  @override
  String get navigation_bin => 'Papelera';

  @override
  String get navigation_settings => 'Ajustes';

  @override
  String get navigation_settings_appearance => 'Apariencia';

  @override
  String get navigation_settings_behavior => 'Comportamiento';

  @override
  String get navigation_settings_editor => 'Editor';

  @override
  String get navigation_settings_backup => 'Copia de seguridad';

  @override
  String get navigation_settings_about => 'Acerca de';

  @override
  String get button_sort_title => 'Título';

  @override
  String get button_sort_ascending => 'Ascendente';

  @override
  String get settings_appearance => 'Apariencia';

  @override
  String get settings_appearance_description => 'Idioma, tema, tamaño del texto, fichas de notas';

  @override
  String get settings_appearance_application => 'Aplicación';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_language_contribute => 'Contribuir';

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
  String get settings_dynamic_theming_description => 'Generar colores desde el sistema';

  @override
  String get settings_black_theming => 'Negro puro';

  @override
  String get settings_black_theming_description => 'Fondo negro puro para el tema oscuro';

  @override
  String get settings_text_scaling => 'Escala del texto';

  @override
  String get settings_appearance_notes_tiles => 'Fichas de las notas';

  @override
  String get settings_show_titles_only => 'Sólo títulos';

  @override
  String get settings_show_titles_only_description => 'Sólo mostrar los títulos de las notas';

  @override
  String get settings_show_titles_only_disable_in_search_view => 'Deshabilitar mostrar solo los títulos en la búsqueda';

  @override
  String get settings_show_titles_only_disable_in_search_view_description =>
      'Deshabilitar la opción de sólo mostrar los títulos cuando se muestra la vista de búsqueda';

  @override
  String get settings_disable_subdued_note_content_preview => 'No subrayado en vista previa';

  @override
  String get settings_disable_subdued_note_content_preview_description =>
      'Desactiva el color de texto subrayado de la vista previa del contenido de las notas';

  @override
  String get settings_show_tiles_background => 'Fondo';

  @override
  String get settings_show_tiles_background_description => 'Muestra el fondo de tarjetas en las notas';

  @override
  String get settings_show_separators => 'Separadores';

  @override
  String get settings_show_separators_description => 'Mostrar un separador entre las notas';

  @override
  String get settings_behavior => 'Comportamiento';

  @override
  String get settings_behavior_description => 'Confirmaciones, marcar cómo segura, acciones de deslizamiento';

  @override
  String get settings_behavior_application => 'Aplicación';

  @override
  String get settings_confirmations => 'Diálogo de confirmación';

  @override
  String get settings_confirmations_description =>
      'Cuándo mostrar un cuadro de diálogo de confirmación al realizar una acción en una nota';

  @override
  String get settings_confirmations_title_none => 'Nunca';

  @override
  String get settings_confirmations_title_irreversible => 'En acciones irreversibles';

  @override
  String get settings_confirmations_title_all => 'Siempre';

  @override
  String get settings_flag_secure => 'Marcar la aplicación cómo segura';

  @override
  String get settings_flag_secure_description =>
      'Oculta la aplicación de las aplicaciones recientes y previene que se realicen capturas de pantalla';

  @override
  String get settings_behavior_swipe_actions => 'Acciones de deslizamiento';

  @override
  String get settings_swipe_action_right => 'Deslizar a la derecha';

  @override
  String get settings_swipe_action_right_description =>
      'Acción a realizar al deslizar a la derecha la tarjeta se una nota';

  @override
  String get settings_swipe_action_left => 'Desliza a la izquierda';

  @override
  String get settings_swipe_action_left_description =>
      'Acción a realizar al deslizar a la izquierda la tarjeta de una nota';

  @override
  String get settings_editor => 'Editor';

  @override
  String get settings_editor_description => 'Botones, barra de herramientas, modo lectura, espaciado';

  @override
  String get settings_editor_formatting => 'Formato';

  @override
  String get settings_show_undo_redo_buttons => 'Botones deshacer/rehacer';

  @override
  String get settings_show_undo_redo_buttons_description =>
      'Mostrar los botones para deshacer y rehacer cambios en la barra de aplicaciones del editor';

  @override
  String get settings_show_checklist_button => 'Botón de casilla de verificación';

  @override
  String get settings_show_checklist_button_description =>
      'Mostrar el botón para alternar listas en la barra de aplicaciones del editor, ocultándolo de la barra de herramientas del editor si está habilitado';

  @override
  String get settings_show_toolbar => 'Barra de herramientas';

  @override
  String get settings_show_toolbar_description =>
      'Mostrar la barra de herramientas del editor para habilitar el formato avanzado de texto';

  @override
  String get settings_editor_behavior => 'Comportamiento';

  @override
  String get settings_show_editor_mode_button => 'Botón del modo editor';

  @override
  String get settings_show_editor_mode_button_description =>
      'Activar el botón para cambiar el editor entre el modo de edición y el modo de lectura';

  @override
  String get settings_open_editor_reading_mode => 'Abrir en modo de lectura';

  @override
  String get settings_open_editor_reading_mode_description => 'Abrir el editor en modo de lectura por defecto';

  @override
  String get settings_focus_title_on_new_note => 'Enfocar el título';

  @override
  String get settings_focus_title_on_new_note_description =>
      'Enfocar el título en lugar del contenido cuando se crea una nueva nota';

  @override
  String get settings_editor_appearance => 'Apariencia';

  @override
  String get settings_use_paragraph_spacing => 'Espacio entre párrafos';

  @override
  String get settings_use_paragraph_spacing_description => 'Usar espaciado entre párrafos';

  @override
  String get settings_backup => 'Respaldo';

  @override
  String get settings_backup_description => 'Exportación manual y automática, cifrado, importación';

  @override
  String get settings_backup_import => 'Importar';

  @override
  String get settings_import => 'Importar';

  @override
  String get settings_import_description => 'Importar notas desde un archivo JSON';

  @override
  String get settings_backup_manual_export => 'Exportar manualmente';

  @override
  String get settings_export_json => 'Exportar a JSON';

  @override
  String get settings_export_json_description =>
      'Exportar inmediatamente las notas a un archivo JSON (bin incluido) que puede ser importado de nuevo';

  @override
  String get settings_export_markdown => 'Exportar a Markdown';

  @override
  String get settings_export_markdown_description =>
      'Exportar inmediatamente las notas a un archivo Markdown (bin incluido)';

  @override
  String get settings_backup_auto_export => 'Exportación automática';

  @override
  String get settings_auto_export => 'Exportación automática';

  @override
  String get settings_auto_export_description =>
      'Exportar automáticamente las notas a un archivo JSON (bin incluido) que puede ser importado de nuevo';

  @override
  String get settings_auto_export_frequency => 'Frecuencia';

  @override
  String settings_auto_export_frequency_value(String frequency) {
    String _temp0 = intl.Intl.selectLogic(
      frequency,
      {
        '1': 'día',
        '7': 'semana',
        '14': '¡2 semanas',
        '30': 'mes',
        'other': '$frequency días',
      },
    );
    return '¡Cada $_temp0';
  }

  @override
  String get settings_auto_export_frequency_description => 'Frecuencia de la exportación automática de las notas';

  @override
  String get settings_auto_export_encryption => 'Encriptación';

  @override
  String get settings_auto_export_encryption_description =>
      'Encriptar el título y el contenido de las notas con una contraseña';

  @override
  String get settings_auto_export_directory => 'Directorio';

  @override
  String get settings_auto_export_directory_description =>
      'Directorio donde guardar las exportaciones automáticas de las notas';

  @override
  String get settings_about => 'Acerca de';

  @override
  String get settings_about_description => 'Información, ayuda, enlaces';

  @override
  String get settings_about_application => 'Aplicación';

  @override
  String get settings_build_mode => 'Modo de compilación';

  @override
  String get settings_build_mode_release => 'Versión';

  @override
  String get settings_build_mode_debug => 'Depuración';

  @override
  String get settings_about_help => 'Ayuda';

  @override
  String get settings_github_issues => 'Reporta errores o solicita nuevas características';

  @override
  String get settings_github_issues_description =>
      'Reportar un error o solicitar una característica creando un problema de GitHub';

  @override
  String get settings_github_discussions => 'Hacer una pregunta';

  @override
  String get settings_github_discussions_description => 'Hacer una pregunta en las discusiones de GitHub';

  @override
  String get settings_get_in_touch => 'Contactar con el desarrollador';

  @override
  String settings_get_in_touch_description(Object email) {
    return 'Póngase en contacto con el desarrollador por correo electrónico en $email';
  }

  @override
  String get settings_about_links => 'Enlaces';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Da un vistazo al código fuente';

  @override
  String get settings_localizations => 'Crowdin';

  @override
  String get settings_localizations_description => 'Añade o mejora las localizaciones en el proyecto Crowdin';

  @override
  String get settings_licence => 'Licencia';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get hint_title => 'Título';

  @override
  String get hint_note => 'Nota';

  @override
  String get hint_link => 'Enlace';

  @override
  String get dialog_export_encryption_password => 'Contraseña';

  @override
  String get tooltip_toggle_checkbox => 'Alternar casilla';

  @override
  String get tooltip_toggle_pins => 'Alternar fijado';

  @override
  String get tooltip_fab_add_note => 'Agregar una nota';

  @override
  String get tooltip_fab_empty_bin => 'Vaciar la papelera';

  @override
  String get tooltip_fab_toggle_editor_mode_edit => 'Cambiar al modo de edición';

  @override
  String get tooltip_fab_toggle_editor_mode_read => 'Cambiar al modo de lectura';

  @override
  String get tooltip_layout_list => 'Vista en lista';

  @override
  String get tooltip_layout_grid => 'Vista en cuadrícula';

  @override
  String get tooltip_sort => 'Ordenar las notas';

  @override
  String get tooltip_search => 'Buscar entre las notas';

  @override
  String get tooltip_unselect_all => 'Deseleccionar todo';

  @override
  String get tooltip_delete => 'Eliminar';

  @override
  String get tooltip_permanently_delete => 'Eliminar permanentemente';

  @override
  String get tooltip_restore => 'Restaurar';

  @override
  String get tooltip_reset => 'Restablecer';

  @override
  String get dialog_add_link => 'Agregar un vínculo';

  @override
  String get dialog_delete => 'Eliminar';

  @override
  String dialog_delete_body(int count) {
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
  String get dialog_permanently_delete => 'Eliminar permanentemente';

  @override
  String dialog_permanently_delete_body(int count) {
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
  String get dialog_restore => 'Restaurar';

  @override
  String dialog_restore_body(int count) {
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
  String get dialog_empty_bin => 'Vaciar la papelera';

  @override
  String get dialog_empty_bin_body =>
      '¿Realmente quieres restaurar la papelera? No podrás restaurar las notas en ella.';

  @override
  String get dialog_export_encryption_switch => 'Encriptar la exportación JSON';

  @override
  String get dialog_export_encryption_description =>
      'El título y el contenido de las notas serán cifrados usando su contraseña. Debe ser generado aleatoriamente, exactamente 32 caracteres de largo, fuerte (al menos 1 minúscula, 1 mayúscula, 1 número y 1 carácter especial) y almacenado de forma segura.';

  @override
  String get dialog_export_encryption_secondary_description_auto =>
      'Esta contraseña se utilizará para todas las exportaciones automáticas futuras.';

  @override
  String get dialog_export_encryption_secondary_description_manual =>
      'Esta contraseña sólo se usará para esta exportación.';

  @override
  String get dialog_export_encryption_password_invalid => 'Inválido';

  @override
  String get dialog_import_encryption_password_description =>
      'Esta exportación está encriptada. Para importarla, necesita proporcionar la contraseña utilizada para encriptarla.';

  @override
  String get dialog_import_encryption_password_error =>
      'el desencriptado de la exportación falló. Por favor, compruebe que proporcionó la misma contraseña que la que utilizó para encriptar la exportación.';

  @override
  String get button_sort_date => 'Fecha';

  @override
  String get placeholder_notes => 'No hay notas';

  @override
  String get placeholder_bin => 'No hay notas eliminadas';

  @override
  String get action_disabled => 'Desactivado';

  @override
  String get action_pin => 'Fijar';

  @override
  String get action_unpin => 'Desfijar';

  @override
  String get action_delete => 'Eliminar';

  @override
  String get action_restore => 'Restaurar';

  @override
  String get action_delete_permanently => 'Eliminar permanentemente';

  @override
  String get action_about => 'Acerca de';

  @override
  String get about_last_edited => 'Última edición';

  @override
  String get about_created => 'Creación';

  @override
  String get about_words => 'Palabras';

  @override
  String get about_characters => 'Caracteres';

  @override
  String get about_time_at => 'a las';

  @override
  String get snack_bar_copied => 'Contenido de la nota copiada al portapapeles.';

  @override
  String get snack_bar_import_success => 'Las notas fueron importadas exitosamente.';

  @override
  String get snack_bar_export_success => 'Las notas fueron exportadas exitosamente.';

  @override
  String get snack_bar_logs_copied => 'The logs were copied to your clipboard.';

  @override
  String get snack_bar_logs_exported => 'The logs were successfully exported.';

  @override
  String get action_add_note_title => 'Agregar una nota';

  @override
  String get welcome_note_title => 'Bienvenido a Material Notes !';

  @override
  String get welcome_note_content => 'Notas simples, locales, en Material Design';
}
