import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

// ignore_for_file: type=lint

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
  String get navigation_settings_appearance => 'Персонализация';

  @override
  String get navigation_settings_behavior => 'Поведение';

  @override
  String get navigation_settings_editor => 'Редактор';

  @override
  String get navigation_settings_backup => 'Резервное копирование';

  @override
  String get navigation_settings_about => 'О приложении';

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
  String get settings_appearance_description => 'Язык, тема, стиль заметок';

  @override
  String get settings_appearance_application => 'Приложение';

  @override
  String get settings_appearance_notes_tiles => 'Стиль заметок';

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
  String get settings_dynamic_theming_description => 'Использовать цвет, установленный в системе';

  @override
  String get settings_black_theming => 'Натуральный чёрный';

  @override
  String get settings_black_theming_description => 'Использовать чёрный фон при тёмной теме оформления';

  @override
  String get settings_show_titles_only => 'Titles only';

  @override
  String get settings_show_titles_only_description =>
      'Only show the titles of the notes so more of them can be displayed';

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
  String get settings_show_tiles_background => 'Фон';

  @override
  String get settings_show_tiles_background_description => 'Показывать задний фон у заметок';

  @override
  String get settings_show_separators => 'Разделители';

  @override
  String get settings_show_separators_description => 'Показывать разделитель между заметками';

  @override
  String get settings_behavior => 'Поведение';

  @override
  String get settings_behavior_application => 'Приложение';

  @override
  String get settings_behavior_description => 'Диалоги подтверждения, действия при свайпе';

  @override
  String get settings_behavior_swipe_actions => 'Действия при свайпе';

  @override
  String get settings_confirmations => 'Диалоги подтверждения';

  @override
  String get settings_confirmations_description =>
      'Показать диалоги подтверждения при закреплении или удалении заметок';

  @override
  String get settings_swipe_action_right => 'Действие при свайпе вправо';

  @override
  String get settings_swipe_action_right_description =>
      'Действие, которое будет выполняться при свайпе вправо по заметке';

  @override
  String get settings_swipe_action_left => 'Действие при свайпе влево';

  @override
  String get settings_swipe_action_left_description =>
      'Действие, которое будет выполняться при свайпе влево по заметке';

  @override
  String get settings_flag_secure => 'Помечать приложение как защищённое';

  @override
  String get settings_flag_secure_description =>
      'Скрывать приложение из недавних приложений и предотвращать создание скриншотов';

  @override
  String get settings_editor => 'Редактор';

  @override
  String get settings_editor_formatting => 'Форматирование';

  @override
  String get settings_editor_behavior => 'Behavior';

  @override
  String get settings_editor_appearance => 'Персонализация';

  @override
  String get settings_editor_description => 'Кнопки, панель инструментов, интервал';

  @override
  String get settings_show_undo_redo_buttons => 'Кнопки отмены/повтора';

  @override
  String get settings_show_undo_redo_buttons_description => 'Показывать кнопки отмены/повтора изменений в редакторе';

  @override
  String get settings_show_checklist_button => 'Кнопка для переключения чек-листов';

  @override
  String get settings_show_checklist_button_description =>
      'Переместить кнопку для переключения чек-листов из панели инструментов в панель редактора';

  @override
  String get settings_show_toolbar => 'Панель инструментов';

  @override
  String get settings_show_toolbar_description => 'Показать панель инструментов для расширенного форматирования текста';

  @override
  String get settings_focus_title_on_new_note => 'Focus the title';

  @override
  String get settings_focus_title_on_new_note_description =>
      'Focus the title instead of the content when creating a new note';

  @override
  String get settings_use_paragraph_spacing => 'Расстояние между абзацами';

  @override
  String get settings_use_paragraph_spacing_description => 'Применять интервал между абзацами';

  @override
  String get settings_backup => 'Резервное копирование';

  @override
  String get settings_backup_description => 'Экспорт, импорт';

  @override
  String get settings_backup_auto_export => 'Automatic export';

  @override
  String get settings_backup_manual_export => 'Manual export';

  @override
  String get settings_backup_import => 'Импорт';

  @override
  String get settings_import => 'Импорт заметок';

  @override
  String get settings_import_description => 'Импортировать заметки из JSON–файла';

  @override
  String get settings_import_success => 'Заметки были успешно импортированы.';

  @override
  String get settings_auto_export => 'Автоматический экспорт в формате JSON';

  @override
  String get settings_auto_export_description =>
      'Автоматически экспортировать заметки в формате JSON (включая заметки из корзины)';

  @override
  String get settings_auto_export_frequency => 'Frequency';

  @override
  String settings_auto_export_frequency_description(String frequency) {
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
    return 'Automatically export the notes every $_temp0';
  }

  @override
  String get settings_auto_export_encryption => 'Encryption';

  @override
  String get settings_auto_export_encryption_description =>
      'Encrypt the title and the content of the notes with a password';

  @override
  String get settings_auto_export_directory => 'Directory';

  @override
  String settings_auto_export_directory_description(Object autoExportDirectory) {
    return 'Save the automatic exports in $autoExportDirectory';
  }

  @override
  String get settings_export_success => 'Заметки были успешно экспортированы.';

  @override
  String get settings_export_json => 'Экспортировать в формате JSON';

  @override
  String get settings_export_json_description =>
      'Моментально экспортировать заметки в формате JSON (включая заметки из корзины)';

  @override
  String get settings_export_markdown => 'Экспортировать в формате Markdown';

  @override
  String get settings_export_markdown_description =>
      'Моментально экспортировать заметки в формате Markdown (включая заметки из корзины)';

  @override
  String get settings_about => 'О приложении';

  @override
  String get settings_about_application => 'Приложение';

  @override
  String get settings_about_links => 'Ссылки';

  @override
  String get settings_about_help => 'Справка';

  @override
  String get settings_about_description => 'Информация, справка, GitHub, лицензия';

  @override
  String get settings_build_mode => 'Режим сборки';

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
  String get settings_github_issues => 'Сообщить об ошибке';

  @override
  String get settings_github_issues_description => 'Сообщить об ошибке через GitHub';

  @override
  String get settings_github_discussions => 'Задать вопрос';

  @override
  String get settings_github_discussions_description => 'Задайте вопрос на обсуждениях в GitHub';

  @override
  String get settings_get_in_touch => 'Связаться с разработчиком';

  @override
  String settings_get_in_touch_description(Object email) {
    return 'Свяжитесь с разработчиком по почте contact@maelchiotti.dev';
  }

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
  String get tooltip_reset => 'Reset';

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
  String dialog_auto_export_frequency_slider_label(String frequency) {
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
  String get dialog_export_encryption_switch => 'Зашифровать экспорт в формате JSON';

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
  String get dialog_export_encryption_password_invalid => 'Неверно';

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
  String get swipe_action_disabled => 'Отключено';

  @override
  String get swipe_action_delete => 'Удалить';

  @override
  String get swipe_action_pin => 'Закрепить';

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
