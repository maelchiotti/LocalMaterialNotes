import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get app_tagline => 'Notes simples, locales, en material design';

  @override
  String app_about(Object appName) {
    return '$appName est une application de prise de notes textuelles, qui vise la simplicité. Elle adopte le style Material Design. Elle stocke les notes localement et n\'a aucune permission internet, vous êtes donc le seul à pouvoir accéder aux notes.';
  }

  @override
  String get navigation_notes => 'Notes';

  @override
  String get navigation_bin => 'Corbeille';

  @override
  String get navigation_settings => 'Paramètres';

  @override
  String get error_error => 'Erreur';

  @override
  String get error_permission => 'Échec lors de la demande de permission pour écrire le fichier.';

  @override
  String get error_read_file => 'Échec lors de la lecture du fichier.';

  @override
  String get settings_appearance => 'Apparence';

  @override
  String get settings_language => 'Langue';

  @override
  String get settings_theme => 'Thème';

  @override
  String get settings_theme_system => 'Système';

  @override
  String get settings_theme_light => 'Clair';

  @override
  String get settings_theme_dark => 'Sombre';

  @override
  String get settings_dynamic_theming => 'Thème dynamique';

  @override
  String get settings_dynamic_theming_description => 'Générer les couleurs depuis le système';

  @override
  String get settings_black_theming => 'Thème noir';

  @override
  String get settings_black_theming_description => 'Utiliser un fond noir pour le thème sombre';

  @override
  String get settings_editor => 'Éditeur';

  @override
  String get settings_show_undo_redo_buttons => 'Boutons annuler/rétablir';

  @override
  String get settings_show_undo_redo_buttons_description =>
      'Afficher les boutons pour annuler et rétablir les modifications dans l\'éditeur';

  @override
  String get settings_show_checklist_button => 'Bouton case à cocher';

  @override
  String get settings_show_checklist_button_description =>
      'Afficher le bouton pour basculer les cases à cocher dans l\'éditeur';

  @override
  String get settings_show_toolbar => 'Barre d\'outils de l\'éditeur';

  @override
  String get settings_show_toolbar_description =>
      'Afficher la barre d\'outils de l\'éditeur pour permettre le formatage textuel avancé';

  @override
  String get settings_show_separators => 'Séparateurs';

  @override
  String get settings_show_separators_description =>
      'Afficher un séparateur entre les tuiles des notes pour les différencier plus facilement';

  @override
  String get settings_show_tiles_background => 'Arrière plan des tuiles';

  @override
  String get settings_show_tiles_background_description =>
      'Afficher l\'arrière plan des tuiles des notes pour les différencier plus facilement';

  @override
  String get settings_behavior => 'Comportement';

  @override
  String get settings_confirmations => 'Dialogues de confirmation';

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
  String get settings_flag_secure => 'Make app secure';

  @override
  String get settings_flag_secure_description =>
      'Hide the app from the recent apps and prevent screenshots from being made';

  @override
  String get settings_backup => 'Sauvegarde';

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
  String get settings_export_success => 'Les notes ont bien été exportées.';

  @override
  String get settings_export_json => 'Exporter en JSON';

  @override
  String get settings_export_json_description =>
      'Exporter les notes dans un fichier JSON (corbeille incluse) qui peut être réimporté';

  @override
  String get settings_export_markdown => 'Exporter en Markdown';

  @override
  String get settings_export_markdown_description => 'Exporter les notes dans un fichier Markdown (corbeille incluse)';

  @override
  String get settings_import => 'Importer';

  @override
  String get settings_import_description => 'Importer les notes depuis un fichier JSON';

  @override
  String get settings_import_success => 'Les notes ont bien été importées.';

  @override
  String get settings_import_incompatible_prior_v1_5_0 =>
      'Exports made in versions prior to v1.5.0 are not compatible anymore. Please see the pinned issue on GitHub for an easy fix.';

  @override
  String get settings_about => 'À propos';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Jeter un coup d\'œil au code source';

  @override
  String get settings_licence => 'License';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get settings_issue => 'Signaler un bug';

  @override
  String get settings_issue_description => 'Signaler un bug en créant une issue sur GitHub';

  @override
  String get hint_title => 'Titre';

  @override
  String get hint_note => 'Note';

  @override
  String get tooltip_fab_add_note => 'Ajouter une note';

  @override
  String get tooltip_fab_empty_bin => 'Vider la corbeille';

  @override
  String get tooltip_layout_list => 'Vue en liste';

  @override
  String get tooltip_layout_grid => 'Vue en grille';

  @override
  String get tooltip_sort => 'Trier les notes';

  @override
  String get tooltip_search => 'Rechercher parmi les notes';

  @override
  String get tooltip_toggle_checkbox => 'Basculer la case à cocher';

  @override
  String get tooltip_select_all => 'Tout sélectionner';

  @override
  String get tooltip_unselect_all => 'Tout déselectionner';

  @override
  String get tooltip_delete => 'Supprimer';

  @override
  String get tooltip_permanently_delete => 'Supprimer définitivement';

  @override
  String get tooltip_restore => 'Restaurer';

  @override
  String get tooltip_toggle_pins => 'Basculer les épingles';

  @override
  String get button_ok => 'Ok';

  @override
  String get button_close => 'Fermer';

  @override
  String get button_cancel => 'Annuler';

  @override
  String get button_add => 'Ajouter';

  @override
  String get dialog_delete => 'Supprimer';

  @override
  String dialog_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notes',
      one: 'note',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les',
      one: 'la',
      zero: '',
    );
    return 'Voulez-vous vraiment supprimer $count $_temp0 ? Vous pouvez $_temp1 restaurer depuis la corbeille.';
  }

  @override
  String get dialog_delete_body_single =>
      'Voulez-vous vraiment supprimer cette note ? Vous pouvez la restaurer depuis la corbeille.';

  @override
  String get dialog_permanently_delete => 'Supprimer définitivement';

  @override
  String dialog_permanently_delete_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notes',
      one: 'note',
      zero: '',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les',
      one: 'la',
      zero: '',
    );
    return 'Voulez-vous vraiment supprimer définitivement $count $_temp0 ? Vous ne pourrez pas $_temp1 restaurer.';
  }

  @override
  String get dialog_permanently_delete_body_single =>
      'Voulez-vous vraiment supprimer définitivement cette note ? Vous ne pourrez pas la restaurer.';

  @override
  String get dialog_restore => 'Restaurer';

  @override
  String dialog_restore_body(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'notes',
      one: 'note',
      zero: '',
    );
    return 'Voulez-vous vraiment restaurer $count $_temp0 ?';
  }

  @override
  String get dialog_restore_body_single => 'Voulez-vous vraiment restaurer cette note ?';

  @override
  String get dialog_empty_bin => 'Vider la corbeille';

  @override
  String get dialog_empty_bin_body =>
      'Voulez-vous vraiment vider définitivement la corbeille ? Vous ne pourrez pas restaurer les notes qu\'elle contient.';

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
  String get sort_date => 'Date';

  @override
  String get sort_title => 'Titre';

  @override
  String get sort_ascending => 'Croissant';

  @override
  String get placeholder_notes => 'Pas de notes';

  @override
  String get placeholder_bin => 'La corbeille est vide';

  @override
  String get menu_pin => 'Épingler';

  @override
  String get menu_share => 'Partager';

  @override
  String get menu_unpin => 'Désépingler';

  @override
  String get menu_delete => 'Supprimer';

  @override
  String get menu_restore => 'Restaurer';

  @override
  String get menu_delete_permanently => 'Supprimer définitivement';

  @override
  String get menu_about => 'À propos';

  @override
  String get confirmations_title_none => 'Jamais';

  @override
  String get confirmations_title_irreversible => 'Actions irréversibles uniquement';

  @override
  String get confirmations_title_all => 'Toujours';

  @override
  String get swipe_action_disabled => 'Disabled';

  @override
  String get swipe_action_delete => 'Delete';

  @override
  String get swipe_action_pin => 'Pin';

  @override
  String get dismiss_pin => 'Épingler';

  @override
  String get dismiss_unpin => 'Désépingler';

  @override
  String get dismiss_delete => 'Supprimer';

  @override
  String get about_last_edited => 'Dernière modification';

  @override
  String get about_created => 'Création';

  @override
  String get about_words => 'Mots';

  @override
  String get about_characters => 'Caractères';

  @override
  String get time_at => 'à';

  @override
  String get action_add_note_title => 'Ajouter une note';

  @override
  String get welcome_note_title => 'Bienvenue dans Material Notes !';

  @override
  String get welcome_note_content => 'Notes simples, locales, en material design';

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
