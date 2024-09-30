import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get app_tagline => 'Simple, local, material design notes';

  @override
  String app_about(Object appName) {
    return '$appName é um aplicativo de anotações com base em texto, destinado à simplicidade. Abraça Material Design. Ele armazena as notas localmente e não possui nenhuma permissão de internet, então você é o único que pode acessar as notas.';
  }

  @override
  String get error_error => 'Erro';

  @override
  String get error_permission => 'Falha ao obter permissão para gravar o arquivo.';

  @override
  String get error_read_file => 'Falha ao ler o arquivo.';

  @override
  String get navigation_notes => 'Notas';

  @override
  String get navigation_bin => 'Lixeira';

  @override
  String get navigation_settings => 'Configurações';

  @override
  String get navigation_settings_appearance => 'Aparência';

  @override
  String get navigation_settings_behavior => 'Comportamento';

  @override
  String get navigation_settings_editor => 'Editor';

  @override
  String get navigation_settings_backup => 'Backup';

  @override
  String get navigation_settings_about => 'Sobre';

  @override
  String get button_ok => 'Ok';

  @override
  String get button_close => 'Fechar';

  @override
  String get button_cancel => 'Cancelar';

  @override
  String get button_add => 'Adicionar';

  @override
  String get settings_appearance => 'Aparência';

  @override
  String get settings_appearance_description => 'Idioma, tema, blocos de notas';

  @override
  String get settings_appearance_application => 'Aplicativo';

  @override
  String get settings_appearance_notes_tiles => 'Blocos de notas';

  @override
  String get settings_language => 'Idioma';

  @override
  String get settings_language_contribute => 'Contribute';

  @override
  String get settings_theme => 'Tema';

  @override
  String get settings_theme_system => 'Sistema';

  @override
  String get settings_theme_light => 'Claro';

  @override
  String get settings_theme_dark => 'Escuro';

  @override
  String get settings_dynamic_theming => 'Tema dinâmico';

  @override
  String get settings_dynamic_theming_description => 'Gerar cores a partir do sistema';

  @override
  String get settings_black_theming => 'Tema preto';

  @override
  String get settings_black_theming_description => 'Use um fundo preto no modo escuro';

  @override
  String get settings_text_scaling => 'Text scaling';

  @override
  String get settings_show_titles_only => 'Titles only';

  @override
  String get settings_show_titles_only_description => 'Only show the titles of the notes';

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
  String get settings_show_tiles_background => 'Plano de Fundo';

  @override
  String get settings_show_tiles_background_description => 'Show the background of the notes tiles';

  @override
  String get settings_show_separators => 'Separadores';

  @override
  String get settings_show_separators_description => 'Show a separator between the notes tiles';

  @override
  String get settings_behavior => 'Comportamento';

  @override
  String get settings_behavior_application => 'Aplicativo';

  @override
  String get settings_behavior_description => 'Confirmações, ações de deslizar';

  @override
  String get settings_behavior_swipe_actions => 'Ações de deslizar';

  @override
  String get settings_confirmations => 'Diálogos de confirmação';

  @override
  String get settings_confirmations_description =>
      'Mostrar as caixas de diálogo de confirmação para ações como fixar e excluir notas';

  @override
  String get settings_swipe_action_right => 'Ação de deslizar para a direita';

  @override
  String get settings_swipe_action_right_description =>
      'Ação a ser acionada quando um deslizamento para a direita é executado nos blocos de notas';

  @override
  String get settings_swipe_action_left => 'Ação de deslizar para a esquerda';

  @override
  String get settings_swipe_action_left_description =>
      'Ação a ser acionada quando um deslizamento para a esquerda é executado nos blocos de notas';

  @override
  String get settings_flag_secure => 'Sinalizar o aplicativo como seguro';

  @override
  String get settings_flag_secure_description =>
      'Ocultar o aplicativo dos aplicativos recentes e impedir que capturas de tela sejam feitas';

  @override
  String get settings_editor => 'Editor';

  @override
  String get settings_editor_formatting => 'Formatação';

  @override
  String get settings_editor_behavior => 'Behavior';

  @override
  String get settings_editor_appearance => 'Aparência';

  @override
  String get settings_editor_description => 'Botões, barra de ferramentas, espaçamento';

  @override
  String get settings_show_undo_redo_buttons => 'Botões desfazer/refazer';

  @override
  String get settings_show_undo_redo_buttons_description =>
      'Mostrar os botões para desfazer e refazer alterações na barra de edição do aplicativo';

  @override
  String get settings_show_checklist_button => 'Botão lista de verificação';

  @override
  String get settings_show_checklist_button_description =>
      'Mostrar o botão para alternar listas de verificação na barra de aplicativos do editor, ocultando-o da barra de ferramentas do editor, se ativado';

  @override
  String get settings_show_toolbar => 'Barra de ferramentas';

  @override
  String get settings_show_toolbar_description =>
      'Mostrar a barra de ferramentas do editor para ativar a formatação avançada de texto';

  @override
  String get settings_show_editor_mode_button => 'Editor mode button';

  @override
  String get settings_show_editor_mode_button_description =>
      'Enable the button to toggle the editor between editing mode and viewing mode';

  @override
  String get settings_open_editor_reading_mode => 'Open in reading mode';

  @override
  String get settings_open_editor_reading_mode_description => 'Open the editor in reading mode by default';

  @override
  String get settings_focus_title_on_new_note => 'Focus the title';

  @override
  String get settings_focus_title_on_new_note_description =>
      'Focus the title instead of the content when creating a new note';

  @override
  String get settings_use_paragraph_spacing => 'Espaçamento dos parágrafos';

  @override
  String get settings_use_paragraph_spacing_description => 'Usar espaçamento entre parágrafos';

  @override
  String get settings_backup => 'Backup';

  @override
  String get settings_backup_description => 'Exportar, importar';

  @override
  String get settings_backup_auto_export => 'Automatic export';

  @override
  String get settings_backup_manual_export => 'Manual export';

  @override
  String get settings_backup_import => 'Importar';

  @override
  String get settings_import => 'Importar';

  @override
  String get settings_import_description => 'Importar anotações de um arquivo JSON';

  @override
  String get settings_import_success => 'As anotações foram importadas com sucesso.';

  @override
  String get settings_auto_export => 'Automatic export';

  @override
  String get settings_auto_export_description =>
      'Exportar automaticamente as notas para um arquivo JSON (lixeira incluída) que pode ser importado de volta';

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
  String get settings_export_success => 'As anotações foram exportadas com sucesso.';

  @override
  String get settings_export_json => 'Exportar como JSON';

  @override
  String get settings_export_json_description =>
      'Exporte imediatamente as notas para um arquivo JSON (lixeira incluída) que pode ser importado de volta';

  @override
  String get settings_export_markdown => 'Exportar como Markdown';

  @override
  String get settings_export_markdown_description =>
      'Exporte imediatamente as notas para um arquivo Markdown (lixeira incluída)';

  @override
  String get settings_about => 'Sobre';

  @override
  String get settings_about_application => 'Aplicativo';

  @override
  String get settings_about_links => 'Links';

  @override
  String get settings_about_help => 'Ajuda';

  @override
  String get settings_about_description => 'Informação, ajuda, GitHub, licença';

  @override
  String get settings_build_mode => 'Build mode';

  @override
  String get settings_build_mode_release => 'Release';

  @override
  String get settings_build_mode_debug => 'Debug';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Dê uma olhada no código-fonte';

  @override
  String get settings_localizations => 'Crowdin';

  @override
  String get settings_localizations_description => 'Add or improve the localizations on the Crowdin project';

  @override
  String get settings_licence => 'Licença';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get settings_github_issues => 'Report a bug or request a feature';

  @override
  String get settings_github_issues_description => 'Report a bug or request a feature by creating a GitHub issue';

  @override
  String get settings_github_discussions => 'Fazer uma pergunta';

  @override
  String get settings_github_discussions_description => 'Fazer uma pergunta nas discussões do GitHub';

  @override
  String get settings_get_in_touch => 'Contatar o desenvolvedor';

  @override
  String settings_get_in_touch_description(Object email) {
    return 'Contact the developer via mail at $email';
  }

  @override
  String get hint_title => 'Título';

  @override
  String get hint_note => 'Anotação';

  @override
  String get tooltip_fab_add_note => 'Adicionar uma anotação';

  @override
  String get tooltip_fab_empty_bin => 'Esvaziar a lixeira';

  @override
  String get tooltip_fab_toggle_editor_mode_edit => 'Switch to editing mode';

  @override
  String get tooltip_fab_toggle_editor_mode_read => 'Switch to reading mode';

  @override
  String get tooltip_layout_list => 'Visualizar em lista';

  @override
  String get tooltip_layout_grid => 'Visualizar em grade';

  @override
  String get tooltip_sort => 'Sort the notes';

  @override
  String get tooltip_search => 'Pesquisar por anotações';

  @override
  String get tooltip_toggle_checkbox => 'Alternar caixas de seleção';

  @override
  String get tooltip_select_all => 'Selecionar tudo';

  @override
  String get tooltip_unselect_all => 'Desmarcar tudo';

  @override
  String get tooltip_delete => 'Excluir';

  @override
  String get tooltip_permanently_delete => 'Excluir permanentemente';

  @override
  String get tooltip_restore => 'Restaurar';

  @override
  String get tooltip_toggle_pins => 'Alternar fixados';

  @override
  String get tooltip_reset => 'Reset';

  @override
  String get dialog_add_link => 'Add a link';

  @override
  String get dialog_link => 'Link';

  @override
  String get dialog_delete => 'Excluir';

  @override
  String dialog_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'anotações',
      one: 'anotação',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'elas',
      one: 'ela',
    );
    return 'Você realmente deseja excluir $count $_temp0? Você pode restaurar $_temp1 na lixeira.';
  }

  @override
  String get dialog_delete_body_single =>
      'Você realmente deseja excluir esta anotação? Você pode restaurá-la da lixeira.';

  @override
  String get dialog_permanently_delete => 'Excluir permanentemente';

  @override
  String dialog_permanently_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'anotações',
      one: 'anotação',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'elas',
      one: 'ela',
    );
    return 'Você realmente deseja excluir permanentemente $count $_temp0? Você não poderá restaurar $_temp1.';
  }

  @override
  String get dialog_permanently_delete_body_single =>
      'Você realmente deseja excluir permanentemente esta anotação? Você não poderá restaurar ela.';

  @override
  String get dialog_restore => 'Restaurar';

  @override
  String dialog_restore_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'anotações',
      one: 'anotação',
    );
    return 'Você realmente deseja restaurar $count $_temp0?';
  }

  @override
  String get dialog_restore_body_single => 'Você realmente deseja restaurar esta anotação?';

  @override
  String get dialog_empty_bin => 'Esvaziar a lixeira';

  @override
  String get dialog_empty_bin_body =>
      'Você realmente deseja esvaziar permanentemente a lixeira? Você não poderá restaurar as notas que ele contém.';

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
  String get dialog_export_encryption_switch => 'Criptografar a exportação JSON';

  @override
  String get dialog_export_encryption_description =>
      'O título e o conteúdo das notas serão criptografados com sua senha. Deve ser gerado aleatoriamente, com exatamente 32 caracteres, forte (pelo menos 1 minúsculo, 1 maiúsculo, 1 número e 1 caractere especial) e armazenado de forma segura.';

  @override
  String get dialog_export_encryption_secondary_description_auto =>
      'Esta senha será usada para todas as exportações automáticas futuras.';

  @override
  String get dialog_export_encryption_secondary_description_manual =>
      'Esta senha será usada apenas para esta exportação.';

  @override
  String get dialog_export_encryption_password_hint => 'Senha';

  @override
  String get dialog_export_encryption_password_invalid => 'Inválido';

  @override
  String get dialog_import_encryption_password_description =>
      'Esta exportação é criptografada. Para importá-lo, você precisa fornecer a senha usada para criptografá-la.';

  @override
  String get dialog_import_encryption_password_error =>
      'a descriptografia da exportação falhou. Verifique se você forneceu a mesma senha usada para criptografar a exportação.';

  @override
  String get sort_date => 'Data';

  @override
  String get sort_title => 'Título';

  @override
  String get sort_ascending => 'Ascending';

  @override
  String get placeholder_notes => 'Sem anotações';

  @override
  String get placeholder_bin => 'Nenhuma anotação excluída';

  @override
  String get menu_pin => 'Fixar';

  @override
  String get menu_unpin => 'Desafixar';

  @override
  String get menu_copy => 'Copy';

  @override
  String get menu_share => 'Compartilhar';

  @override
  String get menu_delete => 'Excluir';

  @override
  String get menu_restore => 'Restaurar';

  @override
  String get menu_delete_permanently => 'Excluir permanentemente';

  @override
  String get menu_about => 'Sobre';

  @override
  String get confirmations_title_none => 'Nunca';

  @override
  String get confirmations_title_irreversible => 'Somente ações irreversíveis';

  @override
  String get confirmations_title_all => 'Sempre';

  @override
  String get swipe_action_disabled => 'Desabilitado';

  @override
  String get swipe_action_delete => 'Excluir';

  @override
  String get swipe_action_pin => 'Fixar';

  @override
  String get dismiss_pin => 'Fixar';

  @override
  String get dismiss_unpin => 'Desafixar';

  @override
  String get dismiss_delete => 'Excluir';

  @override
  String get about_last_edited => 'Última edição';

  @override
  String get about_created => 'Criado';

  @override
  String get about_words => 'Palavras';

  @override
  String get about_characters => 'Caracteres';

  @override
  String get snack_bar_copied => 'Content of the note copied to the clipboard.';

  @override
  String get action_add_note_title => 'Adicionar anotação';

  @override
  String get welcome_note_title => 'Bem-vindo ao Material Notes!';

  @override
  String get welcome_note_content => 'Simple, local, material design notes';

  @override
  String get time_at => 'at';
}
