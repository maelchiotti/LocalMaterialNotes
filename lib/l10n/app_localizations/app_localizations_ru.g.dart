import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get app_tagline => 'Простые, локальные заметки в стиле material design';

  @override
  String app_about(Object appName) {
    return '$appName – это приложение для создания простых текстовых заметок. Приложение выполнено в стиле Material Design. Оно хранит заметки локально на устройстве и работает без подключения к Интернету, поэтому только вы имеете доступ к заметкам.';
  }

  @override
  String get error_error => 'Ошибка';

  @override
  String get error_permission => 'Не удалось получить разрешение на запись файла.';

  @override
  String get error_read_file => 'Не удалось прочитать файл.';

  @override
  String get navigation_notes => 'Заметки';

  @override
  String get navigation_bin => 'Корзина';

  @override
  String get navigation_settings => 'Настройки';

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
  String get button_ok => 'Оk';

  @override
  String get button_close => 'Закрыть';

  @override
  String get button_cancel => 'Отмена';

  @override
  String get button_add => 'Добавить';

  @override
  String get settings_appearance => 'Персонализация';

  @override
  String get settings_appearance_description => 'Language, theme, notes tiles';

  @override
  String get settings_appearance_application => 'Application';

  @override
  String get settings_appearance_notes_tiles => 'Notes tiles';

  @override
  String get settings_language => 'Язык';

  @override
  String get settings_theme => 'Тема оформления';

  @override
  String get settings_theme_system => 'По умолчанию';

  @override
  String get settings_theme_light => 'Светлая';

  @override
  String get settings_theme_dark => 'Тёмная';

  @override
  String get settings_dynamic_theming => 'Динамические цвета';

  @override
  String get settings_dynamic_theming_description => 'Generate colors from the system';

  @override
  String get settings_black_theming => 'Натуральный чёрный';

  @override
  String get settings_black_theming_description => 'Использовать чёрный фон при тёмном режиме';

  @override
  String get settings_show_separators => 'Separators';

  @override
  String get settings_show_separators_description =>
      'Show a separator between the notes tiles to differentiate them easily';

  @override
  String get settings_show_tiles_background => 'Background';

  @override
  String get settings_show_tiles_background_description => 'Показывать фон у карточек с заметками';

  @override
  String get settings_behavior => 'Поведение';

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
      'Показать диалоги подтверждения при закреплении или удалении заметок';

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
  String get settings_editor => 'Редактор';

  @override
  String get settings_editor_formatting => 'Formatting';

  @override
  String get settings_editor_appearance => 'Appearance';

  @override
  String get settings_editor_description => 'Buttons, toolbar, spacing';

  @override
  String get settings_show_undo_redo_buttons => 'Кнопки отмены/повтора';

  @override
  String get settings_show_undo_redo_buttons_description =>
      'Show the buttons to undo and redo changes in the editor\'s app bar';

  @override
  String get settings_show_checklist_button => 'Кнопка для переключения списков';

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
  String get settings_backup => 'Резервное копирование';

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
      'Автоматически экспортировать заметки в формате JSON (включая заметки из корзины)';

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
  String get settings_auto_export_disabled => 'Отключено';

  @override
  String settings_auto_export_directory(Object directory) {
    return 'Экспортированные заметки находятся в $directory';
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
  String get settings_export_success => 'Заметки были успешно экспортированы.';

  @override
  String get settings_export_json => 'Экспортировать в формате JSON';

  @override
  String get settings_export_json_description =>
      'Immediately export the notes to a JSON file (bin included) that can be imported back';

  @override
  String get settings_export_markdown => 'Экспортировать в формате Markdown';

  @override
  String get settings_export_markdown_description => 'Immediately export the notes to a Markdown file (bin included)';

  @override
  String get settings_import => 'Импорт заметок';

  @override
  String get settings_import_description => 'Импортировать заметки из JSON–файла';

  @override
  String get settings_import_success => 'Заметки были успешно импортированы.';

  @override
  String get settings_about => 'О приложении';

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
  String get settings_github_description => 'Ознакомьтесь с исходным кодом приложения';

  @override
  String get settings_licence => 'Лицензия';

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
  String get hint_title => 'Заголовок';

  @override
  String get hint_note => 'Заметка';

  @override
  String get tooltip_fab_add_note => 'Добавить заметку';

  @override
  String get tooltip_fab_empty_bin => 'Очистить корзину';

  @override
  String get tooltip_layout_list => 'Список';

  @override
  String get tooltip_layout_grid => 'Сетка';

  @override
  String get tooltip_sort => 'Сортировать заметки';

  @override
  String get tooltip_search => 'Поиск заметок';

  @override
  String get tooltip_toggle_checkbox => 'Переключить флажок';

  @override
  String get tooltip_select_all => 'Выбрать все';

  @override
  String get tooltip_unselect_all => 'Отменить выбор';

  @override
  String get tooltip_delete => 'Удалить';

  @override
  String get tooltip_permanently_delete => 'Удалить навсегда';

  @override
  String get tooltip_restore => 'Восстановить';

  @override
  String get tooltip_toggle_pins => 'Закрепить/Открепить';

  @override
  String get dialog_delete => 'Удалить';

  @override
  String dialog_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'заметки',
      many: 'заметок',
      few: 'заметки',
      one: 'заметку',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'их',
      one: 'её',
    );
    return 'Вы действительно хотите удалить $count $_temp0? Вы можете восстановить $_temp1 из корзины.';
  }

  @override
  String get dialog_delete_body_single =>
      'Вы действительно хотите поместить эту заметку в корзину? Вы можете восстановить её из корзины.';

  @override
  String get dialog_permanently_delete => 'Удалить';

  @override
  String dialog_permanently_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'заметки',
      many: 'заметок',
      few: 'заметки',
      one: 'заметку',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'их',
      one: 'её',
    );
    return 'Вы действительно хотите навсегда удалить $count $_temp0? Вы не сможете $_temp1 восстановить.';
  }

  @override
  String get dialog_permanently_delete_body_single =>
      'Вы действительно хотите навсегда удалить эту заметку? Заметка будет безвозвратно удалена.';

  @override
  String get dialog_restore => 'Восстановить';

  @override
  String dialog_restore_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'заметки',
      many: 'заметок',
      few: 'заметки',
      one: 'заметку',
    );
    return 'Вы действительно хотите восстановить $count $_temp0?';
  }

  @override
  String get dialog_restore_body_single => 'Вы действительно хотите восстановить эту заметку?';

  @override
  String get dialog_empty_bin => 'Очистить корзину';

  @override
  String get dialog_empty_bin_body =>
      'Вы действительно хотите отчистить корзину? Все заметки будут безвозвратно удалены.';

  @override
  String get dialog_export_encryption_switch => 'Encrypt the JSON export';

  @override
  String get dialog_export_encryption_description =>
      'Заметки будут зашифрованы паролем. Пароль должен быть сгенерирован случайным образом, длиной в 32 символа (должен содержать минимум 1 строчную букву, 1 заглавную букву, 1 цифру и 1 специальный символ) и храниться в надежном месте.';

  @override
  String get dialog_export_encryption_secondary_description_auto =>
      'Этот пароль будет использован для всех автоматических экспортов заметок.';

  @override
  String get dialog_export_encryption_secondary_description_manual =>
      'Этот пароль будет использоваться только для экспорта текущих заметок.';

  @override
  String get dialog_export_encryption_password_hint => 'Пароль';

  @override
  String get dialog_export_encryption_password_invalid => 'Invalid';

  @override
  String get dialog_import_encryption_password_description =>
      'Данные зашифрованы. Чтобы импортировать данные, нужно ввести пароль.';

  @override
  String get dialog_import_encryption_password_error =>
      'не удалось расшифровать данные. Убедитесь, что вы ввели правильный пароль.';

  @override
  String get sort_date => 'По дате';

  @override
  String get sort_title => 'По заголовку';

  @override
  String get sort_ascending => 'В порядке возрастания';

  @override
  String get placeholder_notes => 'Нет заметок';

  @override
  String get placeholder_bin => 'Нет удаленных заметок';

  @override
  String get menu_pin => 'Закрепить';

  @override
  String get menu_share => 'Поделиться';

  @override
  String get menu_unpin => 'Открепить';

  @override
  String get menu_delete => 'Удалить';

  @override
  String get menu_restore => 'Восстановить';

  @override
  String get menu_delete_permanently => 'Удалить навсегда';

  @override
  String get menu_about => 'О приложении';

  @override
  String get confirmations_title_none => 'Никогда';

  @override
  String get confirmations_title_irreversible => 'Только необратимые действия';

  @override
  String get confirmations_title_all => 'Всегда';

  @override
  String get swipe_action_disabled => 'Disabled';

  @override
  String get swipe_action_delete => 'Delete';

  @override
  String get swipe_action_pin => 'Pin';

  @override
  String get dismiss_pin => 'Закрепить';

  @override
  String get dismiss_unpin => 'Открепить';

  @override
  String get dismiss_delete => 'Удалить';

  @override
  String get about_last_edited => 'Изменено';

  @override
  String get about_created => 'Создано';

  @override
  String get about_words => 'Количество слов';

  @override
  String get about_characters => 'Количество символов';

  @override
  String get time_at => 'в';

  @override
  String get action_add_note_title => 'Добавить заметку';

  @override
  String get welcome_note_title => 'Добро пожаловать в Material Notes!';

  @override
  String get welcome_note_content => 'Простые, локальные заметки в стиле Material Design';
}
