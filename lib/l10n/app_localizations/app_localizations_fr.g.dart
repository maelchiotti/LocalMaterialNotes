import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get app_tagline => 'Notes simples, locales, en material design';

  @override
  String app_about(String appName) {
    return '$appName est une application de prise de notes textuelles, qui vise la simplicité. Elle adopte le style Material Design. Elle stocke les notes localement et n\'a aucune permission internet, vous êtes donc le seul à pouvoir accéder aux notes.';
  }

  @override
  String get error_snack_bar => 'Erreur :';

  @override
  String get error_widget_title => 'Une erreur s\'est produite.';

  @override
  String get error_widget_description =>
      'Veuillez signaler cette erreur sur GitHub ou par mail. Joignez une capture d\'écran de cette page et les logs que vous pouvez copier ou exporter ci-dessous. Par précaution, vous devriez également exporter vos notes.';

  @override
  String get error_widget_disabled_secure_flag =>
      'Le paramètre pour marquer l\'application comme sécurisée est désactivé jusquau prochain redémarrage pour permettre les captures décran.';

  @override
  String get error_widget_button_export_notes => 'Exporter les notes';

  @override
  String get error_widget_button_copy_logs => 'Copier les logs';

  @override
  String get error_widget_button_export_logs => 'Exporter les logs';

  @override
  String get error_widget_button_create_github_issue => 'Créer une issue GitHub';

  @override
  String get error_widget_button_send_mail => 'Envoyer un mail';

  @override
  String get navigation_notes => 'Notes';

  @override
  String get navigation_bin => 'Corbeille';

  @override
  String get navigation_settings => 'Paramètres';

  @override
  String get navigation_settings_appearance => 'Apparence';

  @override
  String get navigation_settings_behavior => 'Comportement';

  @override
  String get navigation_settings_editor => 'Éditeur';

  @override
  String get navigation_settings_backup => 'Sauvegarde';

  @override
  String get navigation_settings_about => 'À propos';

  @override
  String get button_sort_title => 'Titre';

  @override
  String get button_sort_ascending => 'Croissant';

  @override
  String get settings_appearance => 'Apparence';

  @override
  String get settings_appearance_description => 'Langue, thème, mise à l\'échelle du texte, tuiles de notes';

  @override
  String get settings_appearance_application => 'Application';

  @override
  String get settings_language => 'Langue';

  @override
  String get settings_language_contribute => 'Contribuer';

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
  String get settings_dynamic_theming_description => 'Générer des couleurs depuis le système';

  @override
  String get settings_black_theming => 'Thème noir';

  @override
  String get settings_black_theming_description => 'Utilise un fond noir pour le thème sombre';

  @override
  String get settings_text_scaling => 'Mise à l\'échelle du texte';

  @override
  String get settings_appearance_notes_tiles => 'Tuiles de notes';

  @override
  String get settings_show_titles_only => 'Titres uniquement';

  @override
  String get settings_show_titles_only_description => 'Afficher uniquement les titres des notes';

  @override
  String get settings_show_titles_only_disable_in_search_view => 'Désactiver titres uniquement dans la recherche';

  @override
  String get settings_show_titles_only_disable_in_search_view_description =>
      'Désactiver l’option pour afficher uniquement les titres dans la vue de recherche';

  @override
  String get settings_disable_subdued_note_content_preview => 'Aperçu non atténué';

  @override
  String get settings_disable_subdued_note_content_preview_description =>
      'Désactiver la couleur de texte atténuée de l\'aperçu du contenu des notes';

  @override
  String get settings_show_tiles_background => 'Fond';

  @override
  String get settings_show_tiles_background_description => 'Afficher l\'arrière-plan des tuiles de notes';

  @override
  String get settings_show_separators => 'Séparateurs';

  @override
  String get settings_show_separators_description => 'Afficher un séparateur entre les tuiles de notes';

  @override
  String get settings_behavior => 'Comportement';

  @override
  String get settings_behavior_description => 'Confirmations, sécurité, actions de balayage';

  @override
  String get settings_behavior_application => 'Application';

  @override
  String get settings_confirmations => 'Dialogues de confirmation';

  @override
  String get settings_confirmations_description =>
      'Quand afficher un dialogue de confirmation lors de l\'exécution d\'une action sur une note';

  @override
  String get settings_confirmations_title_none => 'Jamais';

  @override
  String get settings_confirmations_title_irreversible => 'Actions irréversibles uniquement';

  @override
  String get settings_confirmations_title_all => 'Toujours';

  @override
  String get settings_flag_secure => 'Marquer l\'application comme sécurisée';

  @override
  String get settings_flag_secure_description =>
      'Masquer l\'application des applications récentes et empêcher la réalisation de captures d\'écran';

  @override
  String get settings_behavior_swipe_actions => 'Actions de balayage';

  @override
  String get settings_swipe_action_right => 'Action de balayage à droite';

  @override
  String get settings_swipe_action_right_description =>
      'Action à déclencher lorsqu\'un balayage vers la droite est effectué sur une tuile de note';

  @override
  String get settings_swipe_action_left => 'Action de balayage à gauche';

  @override
  String get settings_swipe_action_left_description =>
      'Action à déclencher lorsqu\'un balayage vers la gauche est effectué sur une tuile de note';

  @override
  String get settings_editor => 'Éditeur';

  @override
  String get settings_editor_description => 'Boutons, barre d\'outils, mode lecture, espacement';

  @override
  String get settings_editor_formatting => 'Mise en forme';

  @override
  String get settings_show_undo_redo_buttons => 'Boutons annuler/rétablir';

  @override
  String get settings_show_undo_redo_buttons_description =>
      'Afficher les boutons pour annuler et refaire les modifications dans la barre d\'application de l\'éditeur';

  @override
  String get settings_show_checklist_button => 'Bouton case à cocher';

  @override
  String get settings_show_checklist_button_description =>
      'Afficher le bouton pour activer/désactiver les cases à cocher dans la barre d\'application de l\'éditeur, en le cachant de la barre d\'outils de l\'éditeur si activée';

  @override
  String get settings_show_toolbar => 'Barre d\'outils';

  @override
  String get settings_show_toolbar_description =>
      'Afficher la barre d\'outils de l\'éditeur pour permettre la mise en forme textuelle avancée';

  @override
  String get settings_editor_behavior => 'Comportement';

  @override
  String get settings_show_editor_mode_button => 'Bouton du mode édition';

  @override
  String get settings_show_editor_mode_button_description =>
      'Activer le bouton pour basculer entre le mode d\'édition et le mode de lecture';

  @override
  String get settings_open_editor_reading_mode => 'Ouvrir en mode lecture';

  @override
  String get settings_open_editor_reading_mode_description => 'Ouvrir l\'éditeur en mode lecture par défaut';

  @override
  String get settings_focus_title_on_new_note => 'Focaliser le titre';

  @override
  String get settings_focus_title_on_new_note_description =>
      'Focaliser le titre au lieu du contenu lors de la création d\'une nouvelle note';

  @override
  String get settings_editor_appearance => 'Apparence';

  @override
  String get settings_use_paragraph_spacing => 'Espacement entre les paragraphes';

  @override
  String get settings_use_paragraph_spacing_description => 'Utiliser l\'espacement entre les paragraphes';

  @override
  String get settings_backup => 'Sauvegarde';

  @override
  String get settings_backup_description => 'Export manuel et automatique, chiffrement, import';

  @override
  String get settings_backup_import => 'Importer';

  @override
  String get settings_import => 'Importer';

  @override
  String get settings_import_description => 'Importer les notes depuis un fichier JSON';

  @override
  String get settings_backup_manual_export => 'Export manuel';

  @override
  String get settings_export_json => 'Exporter en JSON';

  @override
  String get settings_export_json_description =>
      'Exporter immédiatement les notes vers un fichier JSON (corbeille incluse) qui peut être réimporté';

  @override
  String get settings_export_markdown => 'Exporter en Markdown';

  @override
  String get settings_export_markdown_description =>
      'Exporter immédiatement les notes vers un fichier Markdown (corbeille incluse)';

  @override
  String get settings_backup_auto_export => 'Export automatique';

  @override
  String get settings_auto_export => 'Export automatique';

  @override
  String get settings_auto_export_description =>
      'Exporter les notes automatiquement dans un fichier JSON (corbeille incluse) qui peut être réimporté';

  @override
  String get settings_auto_export_frequency => 'Fréquence';

  @override
  String settings_auto_export_frequency_value(String frequency) {
    String _temp0 = intl.Intl.selectLogic(
      frequency,
      {
        '1': 'Tous les jours',
        '7': 'Toutes les semaines',
        '14': 'Toutes les 2 semaines',
        '30': 'Tous les mois',
        'other': 'Tous les $frequency jours',
      },
    );
    return '$_temp0';
  }

  @override
  String get settings_auto_export_frequency_description => 'Fréquence de l\'export automatique des notes';

  @override
  String get settings_auto_export_encryption => 'Chiffrement';

  @override
  String get settings_auto_export_encryption_description =>
      'Chiffrer le titre et le contenu des notes avec un mot de passe';

  @override
  String get settings_auto_export_directory => 'Dossier';

  @override
  String get settings_auto_export_directory_description => 'Répertoire où stocker les exports automatiques des notes';

  @override
  String get settings_about => 'À propos';

  @override
  String get settings_about_description => 'Information, aide, liens';

  @override
  String get settings_about_application => 'Application';

  @override
  String get settings_build_mode => 'Build mode';

  @override
  String get settings_build_mode_release => 'Production';

  @override
  String get settings_build_mode_debug => 'Debug';

  @override
  String get settings_about_help => 'Aide';

  @override
  String get settings_github_issues => 'Signaler un bug ou proposer une fonctionnalité';

  @override
  String get settings_github_issues_description =>
      'Signaler un bug ou proposer une fonctionnalité en créant une issue GitHub';

  @override
  String get settings_github_discussions => 'Poser une question';

  @override
  String get settings_github_discussions_description => 'Poser une question dans les discussions GitHub';

  @override
  String get settings_get_in_touch => 'Contacter le développeur';

  @override
  String settings_get_in_touch_description(Object email) {
    return 'Contacter le développeur par mail à $email';
  }

  @override
  String get settings_about_links => 'Liens';

  @override
  String get settings_github => 'GitHub';

  @override
  String get settings_github_description => 'Jeter un coup d\'œil au code source';

  @override
  String get settings_localizations => 'Crowdin';

  @override
  String get settings_localizations_description => 'Ajouter ou améliorer les traductions sur le projet Crowdin';

  @override
  String get settings_licence => 'License';

  @override
  String get settings_licence_description => 'AGPL-3.0';

  @override
  String get settings_about_logs => 'Logs';

  @override
  String get settings_copy_logs => 'Copier les logs';

  @override
  String get settings_copy_logs_description => 'Copier les logs de l\'application dans le presse-papiers';

  @override
  String get settings_export_logs => 'Exporter les logs';

  @override
  String get settings_export_logs_description => 'Exporter les logs de l\'application vers un fichier texte';

  @override
  String get hint_title => 'Titre';

  @override
  String get hint_note => 'Note';

  @override
  String get hint_link => 'Lien';

  @override
  String get dialog_export_encryption_password => 'Mot de passe';

  @override
  String get tooltip_toggle_checkbox => 'Basculer la case à cocher';

  @override
  String get tooltip_toggle_pins => 'Basculer les épingles';

  @override
  String get tooltip_fab_add_note => 'Ajouter une note';

  @override
  String get tooltip_fab_empty_bin => 'Vider la corbeille';

  @override
  String get tooltip_fab_toggle_editor_mode_edit => 'Basculer en mode édition';

  @override
  String get tooltip_fab_toggle_editor_mode_read => 'Basculer en mode lecture';

  @override
  String get tooltip_layout_list => 'Vue en liste';

  @override
  String get tooltip_layout_grid => 'Vue en grille';

  @override
  String get tooltip_sort => 'Trier les notes';

  @override
  String get tooltip_search => 'Rechercher parmi les notes';

  @override
  String get tooltip_unselect_all => 'Tout déselectionner';

  @override
  String get tooltip_delete => 'Supprimer';

  @override
  String get tooltip_permanently_delete => 'Supprimer définitivement';

  @override
  String get tooltip_restore => 'Restaurer';

  @override
  String get tooltip_reset => 'Réinitialiser';

  @override
  String get dialog_add_link => 'Ajouter un lien';

  @override
  String get dialog_delete => 'Supprimer';

  @override
  String dialog_delete_body(int count) {
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
  String get dialog_permanently_delete => 'Supprimer définitivement';

  @override
  String dialog_permanently_delete_body(int count) {
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
  String get dialog_restore => 'Restaurer';

  @override
  String dialog_restore_body(int count) {
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
  String get dialog_empty_bin => 'Vider la corbeille';

  @override
  String get dialog_empty_bin_body =>
      'Voulez-vous vraiment vider définitivement la corbeille ? Vous ne pourrez pas restaurer les notes qu\'elle contient.';

  @override
  String get dialog_export_encryption_switch => 'Chiffrer l\'export JSON';

  @override
  String get dialog_export_encryption_description =>
      'Le titre et le contenu des notes seront chiffrés à laide de votre mot de passe. Il devrait être généré de façon aléatoire, dexactement 32 caractères de long, fort (au moins 1 minuscule, 1 majuscule, 1 chiffre et 1 caractère spécial) et stocké de manière sécurisée.';

  @override
  String get dialog_export_encryption_secondary_description_auto =>
      'Ce mot de passe sera utilisé pour tous les futurs exports automatiques.';

  @override
  String get dialog_export_encryption_secondary_description_manual =>
      'Ce mot de passe ne sera utilisé que pour cet export.';

  @override
  String get dialog_export_encryption_password_invalid => 'Invalide';

  @override
  String get dialog_import_encryption_password_description =>
      'Cet export est chiffré. Pour l\'importer, vous devez fournir le mot de passe utilisé pour le chiffrer.';

  @override
  String get dialog_import_encryption_password_error =>
      'le déchiffrement de lexport a échoué. Veuillez vérifier que vous avez fourni le même mot de passe que celui que vous avez utilisé pour chiffrer lexport.';

  @override
  String get button_sort_date => 'Date';

  @override
  String get placeholder_notes => 'Pas de notes';

  @override
  String get placeholder_bin => 'Aucune note supprimée';

  @override
  String get action_disabled => 'Désactivé';

  @override
  String get action_pin => 'Épingler';

  @override
  String get action_unpin => 'Désépingler';

  @override
  String get action_share => 'Partager';

  @override
  String get action_delete => 'Supprimer';

  @override
  String get action_restore => 'Restaurer';

  @override
  String get action_delete_permanently => 'Supprimer définitivement';

  @override
  String get action_about => 'À propos';

  @override
  String get about_last_edited => 'Dernière modification';

  @override
  String get about_created => 'Création';

  @override
  String get about_words => 'Mots';

  @override
  String get about_characters => 'Caractères';

  @override
  String get about_time_at => 'à';

  @override
  String get snack_bar_copied => 'Contenu de la note copié dans le presse-papiers.';

  @override
  String get snack_bar_import_success => 'Les notes ont bien été importées.';

  @override
  String get snack_bar_export_success => 'Les notes ont bien été exportées.';

  @override
  String get snack_bar_logs_copied => 'Les logs ont été copiés dans votre presse-papiers.';

  @override
  String get snack_bar_logs_exported => 'Les logs ont été exportés avec succès.';

  @override
  String get action_add_note_title => 'Ajouter une note';

  @override
  String get welcome_note_title => 'Bienvenue dans Material Notes !';

  @override
  String get welcome_note_content => 'Notes simples, locales, en material design';
}
