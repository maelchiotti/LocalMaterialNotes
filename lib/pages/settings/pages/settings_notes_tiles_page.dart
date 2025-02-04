import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/preferences/watched_preferences.dart';
import '../../../providers/preferences/preferences_provider.dart';

/// Notes tiles settings.
class SettingsNotesTilesPage extends ConsumerStatefulWidget {
  /// Settings page related to the notes tiles.
  const SettingsNotesTilesPage({super.key});

  @override
  ConsumerState<SettingsNotesTilesPage> createState() => _SettingsNotesTilesPageState();
}

class _SettingsNotesTilesPageState extends ConsumerState<SettingsNotesTilesPage> {
  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTilesBackground(bool toggled) {
    PreferenceKey.showTilesBackground.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(showTilesBackground: toggled));
  }

  /// Toggles the setting to show the separators between the notes tiles.
  void _toggleShowSeparators(bool toggled) {
    PreferenceKey.showSeparators.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(showSeparators: toggled));
  }

  /// Toggles the setting to show the note type icon on the notes tiles.
  void _toggleShowNoteTypeIcon(bool toggled) {
    PreferenceKey.showNoteTypeIcon.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(showNoteTypeIcon: toggled));
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTitlesOnly(bool toggled) {
    PreferenceKey.showTitlesOnly.set(toggled);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(showTitlesOnly: toggled));
  }

  /// Toggles the setting to show background of the notes tiles.
  void _toggleShowTitlesOnlyDisableInSearchView(bool toggled) {
    setState(() {
      PreferenceKey.showTitlesOnlyDisableInSearchView.set(toggled);
    });
  }

  /// Sets the note content preview maximum lines count to the new [maximumContentPreviewLines].
  void _submittedMaximumContentPreviewLines(double maximumContentPreviewLines) {
    PreferenceKey.maximumContentPreviewLines.set(maximumContentPreviewLines.toInt());

    ref.read(preferencesProvider.notifier).update(
          WatchedPreferences(maximumContentPreviewLines: maximumContentPreviewLines.toInt()),
        );
  }

  @override
  Widget build(BuildContext context) {
    final showTilesBackground = ref.watch(preferencesProvider.select((preferences) => preferences.showTilesBackground));
    final showSeparators = ref.watch(preferencesProvider.select((preferences) => preferences.showSeparators));
    final showNoteTypeIcon = ref.watch(preferencesProvider.select((preferences) => preferences.showNoteTypeIcon));
    final showTitlesOnly = ref.watch(preferencesProvider.select((preferences) => preferences.showTitlesOnly));
    final showTitlesOnlyDisableInSearchView = PreferenceKey.showTitlesOnlyDisableInSearchView.getPreferenceOrDefault();
    final maximumContentPreviewLines =
        ref.watch(preferencesProvider.select((preferences) => preferences.maximumContentPreviewLines));

    return Scaffold(
      appBar: TopNavigation(
        appbar: BasicAppBar(title: l.navigation_settings_notes_tiles),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_page_notes_tiles_appearance_section,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.gradient,
                    title: l.settings_show_tiles_background,
                    description: l.settings_show_tiles_background_description,
                    toggled: showTilesBackground,
                    onChanged: _toggleShowTilesBackground,
                  ),
                  SettingSwitchTile(
                    icon: Icons.safety_divider,
                    title: l.settings_show_separators,
                    description: l.settings_show_separators_description,
                    toggled: showSeparators,
                    onChanged: _toggleShowSeparators,
                  ),
                  SettingSwitchTile(
                    icon: Icons.edit_note,
                    title: l.settings_show_note_type_icon,
                    description: l.settings_show_note_type_icon_description,
                    toggled: showNoteTypeIcon,
                    onChanged: _toggleShowNoteTypeIcon,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_page_notes_tiles_content_section,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.title,
                    title: l.settings_show_titles_only,
                    description: l.settings_show_titles_only_description,
                    toggled: showTitlesOnly,
                    onChanged: _toggleShowTitlesOnly,
                  ),
                  SettingSwitchTile(
                    enabled: showTitlesOnly,
                    icon: Symbols.feature_search,
                    title: l.settings_show_titles_only_disable_in_search_view,
                    description: l.settings_show_titles_only_disable_in_search_view_description,
                    toggled: showTitlesOnlyDisableInSearchView,
                    onChanged: _toggleShowTitlesOnlyDisableInSearchView,
                  ),
                  SettingSliderTile(
                    icon: Icons.short_text,
                    title: l.settings_content_preview_max_lines,
                    description: l.settings_content_preview_max_lines_description,
                    value: '$maximumContentPreviewLines',
                    dialogTitle: l.settings_content_preview_max_lines,
                    label: (maximumContentPreviewLines) => '${maximumContentPreviewLines.toInt()}',
                    min: 1.0,
                    max: 10.0,
                    divisions: 9,
                    initialValue: maximumContentPreviewLines.toDouble(),
                    onSubmitted: _submittedMaximumContentPreviewLines,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
