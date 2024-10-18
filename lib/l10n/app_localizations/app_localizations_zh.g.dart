import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get app_name => '';

  @override
  String get app_tagline => '简单、本地、Material 设计笔记';

  @override
  String app_about(String appName) {
    return '$appName 是基于文本的笔记应用程序，旨在简单。它包含 Material 设计。它在本地存储笔记，并且没有任何互联网权限，因此您是唯一可以访问笔记的人。';
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
  String get navigation_notes => '笔记';

  @override
  String get navigation_bin => '回收站';

  @override
  String get navigation_settings => '设置';

  @override
  String get navigation_settings_appearance => '外观';

  @override
  String get navigation_settings_behavior => '行为';

  @override
  String get navigation_settings_editor => '编辑器';

  @override
  String get navigation_settings_backup => '备份';

  @override
  String get navigation_settings_about => '关于';

  @override
  String get button_sort_title => '标题';

  @override
  String get button_sort_ascending => '升序';

  @override
  String get settings_appearance => '外观';

  @override
  String get settings_appearance_description => '语言、主题、文本缩放、笔记平铺';

  @override
  String get settings_appearance_application => '应用程序';

  @override
  String get settings_language => '语言';

  @override
  String get settings_language_contribute => '贡献';

  @override
  String get settings_theme => '主题';

  @override
  String get settings_theme_system => '系统';

  @override
  String get settings_theme_light => '浅色';

  @override
  String get settings_theme_dark => '深色';

  @override
  String get settings_dynamic_theming => '动态主题';

  @override
  String get settings_dynamic_theming_description => '从系统生成颜色';

  @override
  String get settings_black_theming => '黑色主题';

  @override
  String get settings_black_theming_description => '在深色模式下使用黑色背景';

  @override
  String get settings_text_scaling => '文本缩放';

  @override
  String get settings_appearance_notes_tiles => '笔记平铺';

  @override
  String get settings_show_titles_only => '仅标题';

  @override
  String get settings_show_titles_only_description => '仅显示笔记的标题';

  @override
  String get settings_show_titles_only_disable_in_search_view => '仅在搜索视图中禁用标题';

  @override
  String get settings_show_titles_only_disable_in_search_view_description => '禁用在搜索视图中仅显示标题的选项';

  @override
  String get settings_disable_subdued_note_content_preview => '非柔和预览';

  @override
  String get settings_disable_subdued_note_content_preview_description => '禁用笔记内容预览的柔和文本颜色';

  @override
  String get settings_show_tiles_background => '背景';

  @override
  String get settings_show_tiles_background_description => '显示笔记平铺的背景';

  @override
  String get settings_show_separators => '分隔符';

  @override
  String get settings_show_separators_description => '在笔记平铺之间显示分隔符';

  @override
  String get settings_behavior => '行为';

  @override
  String get settings_behavior_description => '确认、安全标记、滑动操作';

  @override
  String get settings_behavior_application => '应用程序';

  @override
  String get settings_confirmations => '确认对话框';

  @override
  String get settings_confirmations_description => '对笔记执行操作时何时显示确认对话框';

  @override
  String get settings_confirmations_title_none => '从不';

  @override
  String get settings_confirmations_title_irreversible => '仅限不可撤销的操作';

  @override
  String get settings_confirmations_title_all => '始终';

  @override
  String get settings_flag_secure => '将应用标记为安全';

  @override
  String get settings_flag_secure_description => '从最近的应用中隐藏本应用并防止截屏';

  @override
  String get settings_behavior_swipe_actions => '滑动操作';

  @override
  String get settings_swipe_action_right => '向右滑动操作';

  @override
  String get settings_swipe_action_right_description => '在笔记平铺上向右滑动时触发的操作';

  @override
  String get settings_swipe_action_left => '向左滑动操作';

  @override
  String get settings_swipe_action_left_description => '在笔记平铺上向左滑动时触发的操作';

  @override
  String get settings_editor => '编辑器';

  @override
  String get settings_editor_description => '按钮、工具栏、阅读模式、间距';

  @override
  String get settings_editor_formatting => '格式设置';

  @override
  String get settings_show_undo_redo_buttons => '撤销/恢复按钮';

  @override
  String get settings_show_undo_redo_buttons_description => '在编辑器的应用栏中显示撤销和恢复更改的按钮';

  @override
  String get settings_show_checklist_button => '清单按钮';

  @override
  String get settings_show_checklist_button_description => '在编辑器的应用栏中显示切换清单的按钮，如果启用，则将其隐藏在编辑器的工具栏中';

  @override
  String get settings_show_toolbar => '工具栏';

  @override
  String get settings_show_toolbar_description => '显示编辑器的工具栏以启用高级文本格式';

  @override
  String get settings_editor_behavior => '行为';

  @override
  String get settings_show_editor_mode_button => '编辑器模式按钮';

  @override
  String get settings_show_editor_mode_button_description => '启用在编辑模式和阅读模式之间切换编辑器的按钮';

  @override
  String get settings_open_editor_reading_mode => '以阅读模式打开';

  @override
  String get settings_open_editor_reading_mode_description => '默认以阅读模式打开编辑器';

  @override
  String get settings_focus_title_on_new_note => '聚焦标题';

  @override
  String get settings_focus_title_on_new_note_description => '在创建新笔记时聚焦标题而不是内容';

  @override
  String get settings_editor_appearance => '外观';

  @override
  String get settings_use_paragraph_spacing => '段落间距';

  @override
  String get settings_use_paragraph_spacing_description => '在段落之间使用间距';

  @override
  String get settings_backup => '备份';

  @override
  String get settings_backup_description => '手动和自动导出、加密、导入';

  @override
  String get settings_backup_import => '导入';

  @override
  String get settings_import => '导入';

  @override
  String get settings_import_description => '从 JSON 文件导入笔记';

  @override
  String get settings_backup_manual_export => '手动导出';

  @override
  String get settings_export_json => '导出为 JSON';

  @override
  String get settings_export_json_description => '立即将笔记导出到 JSON 文件（包括回收站），可以重新导入';

  @override
  String get settings_export_markdown => '导出为 Markdown';

  @override
  String get settings_export_markdown_description => '立即将笔记导出到 Markdown 文件（包括回收站）';

  @override
  String get settings_backup_auto_export => '自动导出';

  @override
  String get settings_auto_export => '自动导出';

  @override
  String get settings_auto_export_description => '自动将笔记导出到 JSON 文件（包括回收站），可以重新导入';

  @override
  String get settings_auto_export_frequency => '频率';

  @override
  String settings_auto_export_frequency_value(String frequency) {
    String _temp0 = intl.Intl.selectLogic(
      frequency,
      {
        '1': '天',
        '7': '周',
        '14': ' 2 周',
        '30': '月',
        'other': ' $frequency 天',
      },
    );
    return '每$_temp0';
  }

  @override
  String get settings_auto_export_frequency_description => '自动导出笔记的频率';

  @override
  String get settings_auto_export_encryption => '加密';

  @override
  String get settings_auto_export_encryption_description => '用密码加密笔记的标题和内容';

  @override
  String get settings_auto_export_directory => '目录';

  @override
  String get settings_auto_export_directory_description => '存储自动导出笔记的目录';

  @override
  String get settings_about => '关于';

  @override
  String get settings_about_description => '信息、帮助、链接';

  @override
  String get settings_about_application => '应用程序';

  @override
  String get settings_build_mode => '构建模式';

  @override
  String get settings_build_mode_release => 'Release';

  @override
  String get settings_build_mode_debug => 'Debug';

  @override
  String get settings_about_help => '帮助';

  @override
  String get settings_github_issues => '报告错误或请求功能';

  @override
  String get settings_github_issues_description => '通过创建 GitHub 问题来报告错误或请求功能';

  @override
  String get settings_github_discussions => '提问';

  @override
  String get settings_github_discussions_description => '在 GitHub 讨论中提问';

  @override
  String get settings_get_in_touch => '联系开发人员';

  @override
  String settings_get_in_touch_description(Object email) {
    return '通过邮件 $email 联系开发人员';
  }

  @override
  String get settings_about_links => '链接';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => '查看源代码';

  @override
  String get settings_localizations => 'Crowdin';

  @override
  String get settings_localizations_description => '在 Crowdin 项目添加或改进本地化';

  @override
  String get settings_licence => '许可证';

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
  String get hint_title => '标题';

  @override
  String get hint_note => '笔记';

  @override
  String get hint_link => '链接';

  @override
  String get dialog_export_encryption_password => '密码';

  @override
  String get tooltip_toggle_checkbox => '切换复选框';

  @override
  String get tooltip_toggle_pins => '切换置顶';

  @override
  String get tooltip_fab_add_note => '添加笔记';

  @override
  String get tooltip_fab_empty_bin => '清空回收站';

  @override
  String get tooltip_fab_toggle_editor_mode_edit => '切换到编辑模式';

  @override
  String get tooltip_fab_toggle_editor_mode_read => '切换到阅读模式';

  @override
  String get tooltip_layout_list => '列表视图';

  @override
  String get tooltip_layout_grid => '网格视图';

  @override
  String get tooltip_sort => '排序笔记';

  @override
  String get tooltip_search => '搜索笔记';

  @override
  String get tooltip_unselect_all => '取消全选';

  @override
  String get tooltip_delete => '删除';

  @override
  String get tooltip_permanently_delete => '永久删除';

  @override
  String get tooltip_restore => '还原';

  @override
  String get tooltip_reset => '重置';

  @override
  String get dialog_add_link => '添加链接';

  @override
  String get dialog_delete => '删除';

  @override
  String dialog_delete_body(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '个笔记',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '它们',
    );
    return '是否确定要删除 $count $_temp0？您可以从回收站中还原$_temp1。';
  }

  @override
  String get dialog_permanently_delete => '永久删除';

  @override
  String dialog_permanently_delete_body(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '个笔记',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '它们',
    );
    return '是否确定要永久删除 $count $_temp0？您将无法还原$_temp1。';
  }

  @override
  String get dialog_restore => '还原';

  @override
  String dialog_restore_body(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '个笔记',
    );
    return '是否确定要还原 $count $_temp0？';
  }

  @override
  String get dialog_empty_bin => '清空回收站';

  @override
  String get dialog_empty_bin_body => '是否确定要永久清空回收站？您将无法还原其中包含的笔记。';

  @override
  String get dialog_export_encryption_switch => '加密 JSON 导出';

  @override
  String get dialog_export_encryption_description =>
      '笔记的标题和内容将使用您的密码进行加密。密码应随机生成，长度恰好为 32 个字符，具有较强的强度（至少 1 个小写字母、1 个大写字母、1 个数字和 1 个特殊字符），并安全存储。';

  @override
  String get dialog_export_encryption_secondary_description_auto => '此密码将用于将来的所有自动导出。';

  @override
  String get dialog_export_encryption_secondary_description_manual => '此密码仅用于此导出。';

  @override
  String get dialog_export_encryption_password_invalid => '无效';

  @override
  String get dialog_import_encryption_password_description => '此导出已加密。要导入它，您需要提供用于加密它的密码。';

  @override
  String get dialog_import_encryption_password_error => '解密导出失败。请检查您提供的密码是否与加密导出时使用的密码相同。';

  @override
  String get button_sort_date => '日期';

  @override
  String get placeholder_notes => '无笔记';

  @override
  String get placeholder_bin => '没有删除的笔记';

  @override
  String get action_disabled => '已禁用';

  @override
  String get action_pin => '置顶';

  @override
  String get action_unpin => '取消置顶';

  @override
  String get action_delete => '删除';

  @override
  String get action_restore => '还原';

  @override
  String get action_delete_permanently => '永久删除';

  @override
  String get action_about => '关于';

  @override
  String get about_last_edited => '最后编辑';

  @override
  String get about_created => '创建时间';

  @override
  String get about_words => '词数';

  @override
  String get about_characters => '字符';

  @override
  String get about_time_at => '于';

  @override
  String get snack_bar_copied => '笔记内容已复制到剪贴板。';

  @override
  String get snack_bar_import_success => '已成功导入笔记。';

  @override
  String get snack_bar_export_success => '已成功导出笔记。';

  @override
  String get snack_bar_logs_copied => 'The logs were copied to your clipboard.';

  @override
  String get snack_bar_logs_exported => 'The logs were successfully exported.';

  @override
  String get action_add_note_title => '添加笔记';

  @override
  String get welcome_note_title => '欢迎使用 Material Notes！';

  @override
  String get welcome_note_content => '简单、本地、Material 设计笔记';
}
