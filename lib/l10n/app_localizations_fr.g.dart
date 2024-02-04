import 'package:intl/intl.dart' as intl;

import 'app_localizations.g.dart';

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get app_name => 'Material Notes';

  @override
  String get navigation_notes => 'Notes';

  @override
  String get navigation_bin => 'Corbeille';

  @override
  String get navigation_settings => 'Paramètres';

  @override
  String get error_error => 'Erreur';

  @override
  String get error_wrong_email_password => 'Mauvais email ou mot de passe.';

  @override
  String get error_confirm_email => 'Merci de confirmer votre email et de réessayer.';

  @override
  String get error_invalid_email => 'Email invalide';

  @override
  String get error_required => 'Requis';

  @override
  String get error_password_requirements =>
      'Requis:\n• 12 caractères\n• 1 minuscule\n• 1 majuscule\n• 1 nombre\n• 1 caractère spécial (!@#\$&%*^\"\'`<>+=-;:~,._;/\\|()[]{})';

  @override
  String get error_password_do_not_match => 'Les mots de passe ne correspondent pas';

  @override
  String get login_email => 'Email';

  @override
  String get login_password => 'Mot de passe';

  @override
  String get login_log_in => 'Se connecter';

  @override
  String get login_log_out => 'Se déconnecter';

  @override
  String get signup_sign_up => 'S\'inscrire';

  @override
  String get signup_email => 'Email';

  @override
  String get signup_password => 'Mot de passe';

  @override
  String get signup_password_confirmation => 'Confirmer mot de passe';

  @override
  String get signup_confirm_email => 'Merci de confirmer votre email avant de vous connecter.';

  @override
  String get settings_account => 'Compte';

  @override
  String get settings_user => 'Utilisateur';

  @override
  String get settings_log_out => 'Se déconnecter';

  @override
  String settings_log_out_description(Object appName) {
    return 'Se déconnecter de $appName';
  }

  @override
  String get settings_change_password => 'Changer mon mot de passe';

  @override
  String settings_change_password_description(Object appName) {
    return 'Changer mon mot de passe pour $appName';
  }

  @override
  String get settings_change_password_success => 'Votre mot de passe a été changé, veuillez vous reconnecter.';

  @override
  String get settings_appearance => 'Apparence';

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
  String get settings_dynamic_theming_description => 'Génère des couleurs depuis votre système';

  @override
  String get settings_black_theming => 'Thème noir';

  @override
  String get settings_black_theming_description => 'Utilise un fond noir pour le thème sombre';

  @override
  String get settings_language => 'Langue';

  @override
  String get settings_language_restart => 'Merci de recharger l\'application pour que les changements prennent effet.';

  @override
  String get settings_behavior => 'Comportement';

  @override
  String get settings_confirmations => 'Afficher les dialogues de confirmation';

  @override
  String get settings_shortcuts => 'Raccourcis';

  @override
  String get settings_shortcuts_description => 'Lister tous les raccourcis disponibles dans l\'éditeur de texte';

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
  String get shortcut_bold => 'Gras';

  @override
  String get shortcut_italic => 'Italique';

  @override
  String get shortcut_underline => 'Souligné';

  @override
  String get shortcut_undo => 'Annuler';

  @override
  String get shortcut_redo => 'Rétablir';

  @override
  String get action_add_note => 'Ajouter une note';

  @override
  String get label_old_password => 'Ancien mot de passe';

  @override
  String get label_new_password => 'Nouveau mot de passe';

  @override
  String get label_new_password_confirmation => 'Confirmer nouveau mot de passe';

  @override
  String get hint_email => 'Email';

  @override
  String get hint_password => 'Mot de passe';

  @override
  String get hint_password_confirmation => 'Confirmer mot de passe';

  @override
  String get hint_old_password => 'monAncienMotDePasse';

  @override
  String get hint_new_password => 'monNouveauMotDePasse';

  @override
  String get hint_new_password_confirmation => 'monNouveauMotDePasse';

  @override
  String get hint_title => 'Titre';

  @override
  String get hint_collaborator_email => 'collaborateur@exemple.com';

  @override
  String get tooltip_fab_add_note => 'Ajouter une note';

  @override
  String get tooltip_fab_empty_bin => 'Vider la corbeille';

  @override
  String get tooltip_fab_add_collaborator => 'Ajouter un collaborateur';

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
  String get button_close => 'Fermer';

  @override
  String get button_cancel => 'Annuler';

  @override
  String get button_refresh => 'Rafraîchir';

  @override
  String get button_add => 'Ajouter';

  @override
  String get dialog_log_out => 'Se déconnecter';

  @override
  String get dialog_log_out_body => 'Voulez-vous vraiment vous déconnecter ?';

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
  String get dialog_add_collaborator => 'Ajouter un collaborateur';

  @override
  String get dialog_remove_collaborator => 'Retirer ce collaborateur';

  @override
  String get dialog_remove_collaborator_body => 'Voulez-vous vraiment retirer ce collaborateur ?';

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
  String get placeholder_collaborators => 'Pas de collaborateurs';

  @override
  String get menu_pin => 'Épingler';

  @override
  String get menu_share => 'Partager';

  @override
  String get menu_unpin => 'Désépingler';

  @override
  String get menu_collaborate => 'Collaborer';

  @override
  String get menu_delete => 'Supprimer';

  @override
  String get menu_restore => 'Restaurer';

  @override
  String get menu_delete_permanently => 'Supprimer définitivement';

  @override
  String get menu_about => 'À propos';

  @override
  String get notes_untitled => 'Note sans titre';

  @override
  String get confirmations_title_none => 'Jamais';

  @override
  String get confirmations_title_irreversible => 'Actions irréversibles uniquement';

  @override
  String get confirmations_title_all => 'Toujours';

  @override
  String get confirmations_description_none => 'Ne jamais demander de confirmation';

  @override
  String get confirmations_description_irreversible =>
      'Ne demander de confirmation que pour les actions qui ne sont pas réversibles (comme supprimer définitivement des notes de la corbeille)';

  @override
  String get confirmations_description_all =>
      'Toujours demander une confirmation pour les actions importantes même si elles peuvent être annulées (comme supprimer ou restaurer une note)';

  @override
  String get dismiss_pin => 'Épingler';

  @override
  String get dismiss_unpin => 'Désépingler';

  @override
  String get dismiss_delete => 'Supprimer';

  @override
  String get dismiss_permanently_delete => 'Supprimer définitivement';

  @override
  String get dismiss_restore => 'Restaurer';

  @override
  String get collaborators_collaborators => 'Collaborateurs';

  @override
  String get collaborators_owner => 'Propriétaire';

  @override
  String get collaborators_guest => 'Invité';

  @override
  String get collaborators_owner_description =>
      'Vous êtes le propriétaire de cette note.\n\nVous pouvez ajouter ou retirer des collaborateurs. Si vous supprimez cette note, tous les collaborateurs en perdront l\'accès. Ils le regagneront si vous la restaurez.\n\nLimitations:\n- Vous ne pouvez pas vous retirer vous-mêmes des collaborateurs.\n- L\'état d\'épingle est partagé entre tous les collaborateurs.';

  @override
  String get collaborators_guest_description =>
      'Vous avez été invité en tant que collaborateur sur cette note.\n\nVous ne pouvez pas ajouter ni retirer des collaborateurs, seul le propriétaire le peut.\n\nLimitations:\n- Vous ne pouvez pas vous retirer vous-mêmes des collaborateurs.\n- L\'état d\'épingle est partagé entre tous les collaborateurs.';

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
}
