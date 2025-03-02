import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';

/// Notes tiles settings.
class SettingsNotesTilesPage extends ConsumerStatefulWidget {
  /// Settings page related to the notes tiles.
  const SettingsNotesTilesPage({super.key});

  @override
  ConsumerState<SettingsNotesTilesPage> createState() => _SettingsNotesTilesPageState();
}

class _SettingsNotesTilesPageState extends ConsumerState<SettingsNotesTilesPage> {
  /// Toggles the setting to show background of the notes tiles.
  Future<void> _toggleShowTilesBackground(bool toggled) async {
    await PreferenceKey.showTilesBackground.set(toggled);

    setState(() {});
  }

  /// Toggles the setting to show the separators between the notes tiles.
  Future<void> _toggleShowSeparators(bool toggled) async {
    await PreferenceKey.showSeparators.set(toggled);

    setState(() {});
  }

  /// Toggles the setting to show background of the notes tiles.
  Future<void> _toggleShowTitlesOnly(bool toggled) async {
    await PreferenceKey.showTitlesOnly.set(toggled);

    setState(() {});
  }

  /// Toggles the setting to show background of the notes tiles.
  Future<void> _toggleShowTitlesOnlyDisableInSearchView(bool toggled) async {
    await PreferenceKey.showTitlesOnlyDisableInSearchView.set(toggled);

    setState(() {});
  }

  /// Sets the note content preview maximum lines count to the new [maximumContentPreviewLines].
  Future<void> _submittedMaximumContentPreviewLines(double maximumContentPreviewLines) async {
    await PreferenceKey.maximumContentPreviewLines.set(maximumContentPreviewLines.toInt());

    setState(() {});
  }

  /// Toggles the setting to show the note type icon on the notes tiles.
  Future<void> _toggleShowNoteTypeIcon(bool toggled) async {
    await PreferenceKey.showNoteTypeIcon.set(toggled);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final showTilesBackground = PreferenceKey.showTilesBackground.preferenceOrDefault;
    final showSeparators = PreferenceKey.showSeparators.preferenceOrDefault;
    final showTitlesOnly = PreferenceKey.showTitlesOnly.preferenceOrDefault;
    final showTitlesOnlyDisableInSearchView = PreferenceKey.showTitlesOnlyDisableInSearchView.preferenceOrDefault;
    final maximumContentPreviewLines = PreferenceKey.maximumContentPreviewLines.preferenceOrDefault;
    final showNoteTypeIcon = PreferenceKey.showNoteTypeIcon.preferenceOrDefault;

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
                  SettingSwitchTile(
                    icon: Icons.edit_note,
                    title: l.settings_show_note_type_icon,
                    description: l.settings_show_note_type_icon_description,
                    toggled: showNoteTypeIcon,
                    onChanged: _toggleShowNoteTypeIcon,
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
