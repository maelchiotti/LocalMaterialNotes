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
  String get settings_separator => 'Afficher les séparateurs';

  @override
  String get settings_separator_description =>
      'Afficher un séparateur entre les notes pour les différencier plus facilement';

  @override
  String get settings_behavior => 'Comportement';

  @override
  String get settings_confirmations => 'Afficher les dialogues de confirmation';

  @override
  String get settings_backup => 'Sauvegarde';

  @override
  String get settings_export_json => 'Exporter en JSON';

  @override
  String get settings_export_markdown => 'Exporter en Markdown';

  @override
  String get settings_export_json_description =>
      'Exporter les notes dans un fichier JSON (corbeille incluse) qui peut être réimporté';

  @override
  String get settings_export_markdown_description => 'Exporter les notes dans un fichier Markdown (corbeille incluse)';

  @override
  String get settings_export_success => 'Les notes ont bien été exportées.';

  @override
  String settings_export_fail(Object error) {
    return 'L\'export a échoué : $error.';
  }

  @override
  String get settings_import => 'Importer';

  @override
  String get settings_import_description => 'Importer les notes depuis un fichier JSON';

  @override
  String get settings_import_success => 'Les notes ont bien été importées.';

  @override
  String settings_import_fail(Object error) {
    return 'L\'import a échoué : $error.';
  }

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
  String get action_add_note => 'Ajouter une note';

  @override
  String get hint_title => 'Titre';

  @override
  String get hint_note => 'Note';

  @override
  String get tooltip_fab_add_note => 'Ajouter une note';

  @override
  String get tooltip_fab_empty_bin => 'Vider la corbeille';

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
  String get notes_untitled => 'Note sans titre';

  @override
  String get confirmations_title_none => 'Jamais';

  @override
  String get confirmations_title_irreversible => 'Actions irréversibles uniquement';

  @override
  String get confirmations_title_all => 'Toujours';

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
