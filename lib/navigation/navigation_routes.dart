import '../models/label/label.dart';

// ignore_for_file: public_member_api_docs

/// Navigation routes of the application.
enum NavigationRoute {
  // Lock
  lock('/lock'),

  // Notes
  notes('/notes'),
  label('label'),
  editor('/editor'),

  // Labels
  labels('labels'),

  // Archives
  archives('archives'),

  // Bin
  bin('bin'),

  // Settings
  settings('/settings'),
  settingsAppearance('appearance'),
  settingsNotesTiles('notes-tiles'),
  settingsBehavior('behavior'),
  settingsNotesTypes('notes-types'),
  settingsEditor('editor'),
  settingsLabels('labels'),
  settingsBackup('backup'),
  settingsSecurity('security'),
  settingsAccessibility('accessibility'),
  settingsHelp('help'),
  settingsAbout('about'),
  ;

  final String path;

  const NavigationRoute(this.path);

  static String getLabelRouteName(Label label) {
    return 'label_${label.name}';
  }

  static String getLabelRoutePath(Label label) {
    return '${notes.path}/${getLabelRouteName(label)}';
  }
}
