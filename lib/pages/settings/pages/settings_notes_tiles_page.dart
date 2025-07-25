import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/paddings.dart';
import '../../../common/extensions/build_context_extension.dart';
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
      appBar: TopNavigation(appbar: BasicAppBar(title: context.l.navigation_settings_notes_tiles)),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                title: SettingSectionTitle(context.l.settings_page_notes_tiles_appearance_section),
                tiles: [
                  SettingSwitchTile(
                    icon: SettingTileIcon(Icons.gradient),
                    title: Text(context.l.settings_show_tiles_background),
                    description: Text(context.l.settings_show_tiles_background_description),
                    toggled: showTilesBackground,
                    onChanged: _toggleShowTilesBackground,
                  ),
                  SettingSwitchTile(
                    icon: SettingTileIcon(Icons.safety_divider),
                    title: Text(context.l.settings_show_separators),
                    description: Text(context.l.settings_show_separators_description),
                    toggled: showSeparators,
                    onChanged: _toggleShowSeparators,
                  ),
                ],
              ),
              SettingSection(
                title: SettingSectionTitle(context.l.settings_page_notes_tiles_content_section),
                tiles: [
                  SettingSwitchTile(
                    icon: SettingTileIcon(Icons.title),
                    title: Text(context.l.settings_show_titles_only),
                    description: Text(context.l.settings_show_titles_only_description),
                    toggled: showTitlesOnly,
                    onChanged: _toggleShowTitlesOnly,
                  ),
                  SettingSwitchTile(
                    enabled: showTitlesOnly,
                    icon: SettingTileIcon(Symbols.feature_search),
                    title: Text(context.l.settings_show_titles_only_disable_in_search_view),
                    description: Text(context.l.settings_show_titles_only_disable_in_search_view_description),
                    toggled: showTitlesOnlyDisableInSearchView,
                    onChanged: _toggleShowTitlesOnlyDisableInSearchView,
                  ),
                  SettingSliderTile(
                    icon: SettingTileIcon(Icons.short_text),
                    title: Text(context.l.settings_content_preview_max_lines),
                    description: Text(context.l.settings_content_preview_max_lines_description),
                    value: SettingTileValue('$maximumContentPreviewLines'),
                    dialogTitle: context.l.settings_content_preview_max_lines,
                    label: (maximumContentPreviewLines) => '${maximumContentPreviewLines.toInt()}',
                    min: 1.0,
                    max: 10.0,
                    divisions: 9,
                    initialValue: maximumContentPreviewLines.toDouble(),
                    onSubmitted: _submittedMaximumContentPreviewLines,
                  ),
                  SettingSwitchTile(
                    icon: SettingTileIcon(Icons.edit_note),
                    title: Text(context.l.settings_show_note_type_icon),
                    description: Text(context.l.settings_show_note_type_icon_description),
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
