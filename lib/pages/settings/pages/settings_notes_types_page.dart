import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/preferences/watched_preferences.dart';
import '../../../common/system/quick_actions_utils.dart';
import '../../../models/note/types/note_type.dart';
import '../../../providers/preferences/preferences_provider.dart';

/// Notes types settings.
class SettingsNotesTypesPage extends ConsumerStatefulWidget {
  /// Settings page related to the notes types.
  const SettingsNotesTypesPage({super.key});

  @override
  ConsumerState<SettingsNotesTypesPage> createState() => _SettingsNotesTypesPageState();
}

class _SettingsNotesTypesPageState extends ConsumerState<SettingsNotesTypesPage> {
  /// Sets the setting for the available notes types to [availableNotesTypes].
  void onSubmittedAvailableNotesTypes(List<NoteType> availableNotesTypes) {
    PreferenceKey.availableNotesTypes.set(NoteType.toPreference(availableNotesTypes));

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(availableNotesTypes: availableNotesTypes));

    QuickActionsUtils().setQuickActions(context, ref);
  }

  /// Sets the setting for the default share note type to [defaultShareNoteType].
  Future<void> onSubmittedDefaultShareNoteType(NoteType defaultShareNoteType) async {
    await PreferenceKey.defaultShareNoteType.set(defaultShareNoteType.name);

    setState(() {});
  }

  /// Toggles the setting to use spacing between the paragraphs.
  Future<void> _toggleUseParagraphSpacing(bool toggled) async {
    await PreferenceKey.useParagraphsSpacing.set(toggled);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final notesTypes = NoteType.values.map((type) {
      return (value: type, title: type.title, subtitle: null);
    }).toList();
    final availableNotesTypes = ref.watch(
      preferencesProvider.select((preferences) => preferences.availableNotesTypes),
    );
    final availableNotesTypesString = NoteType.availableTypesAsString;

    final shareNotesTypes = NoteType.shareTypes.map((type) {
      return (value: type, title: type.title, subtitle: null);
    }).toList();
    final defaultShareNoteType = NoteType.defaultShareType;

    final useParagraphsSpacing = PreferenceKey.useParagraphsSpacing.preferenceOrDefault;

    return Scaffold(
      appBar: TopNavigation(
        appbar: BasicAppBar(title: l.navigation_settings_notes_types),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_section_types_to_use,
                tiles: [
                  SettingMultipleOptionsTile.detailed(
                    icon: Icons.edit_note,
                    title: l.settings_available_notes_types,
                    value: availableNotesTypesString,
                    description: l.settings_available_notes_types_description,
                    dialogTitle: l.settings_available_notes_types,
                    options: notesTypes,
                    initialOptions: availableNotesTypes,
                    minOptions: 1,
                    onSubmitted: onSubmittedAvailableNotesTypes,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.share,
                    title: l.settings_available_default_share_type,
                    value: defaultShareNoteType.title,
                    description: l.settings_available_default_share_type_description,
                    dialogTitle: l.settings_available_default_share_type,
                    options: shareNotesTypes,
                    initialOption: defaultShareNoteType,
                    onSubmitted: onSubmittedDefaultShareNoteType,
                  ),
                ],
              ),
              SettingSection(
                title: NoteType.richText.title,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.format_line_spacing,
                    title: l.settings_use_paragraph_spacing,
                    description: l.settings_use_paragraph_spacing_description,
                    toggled: useParagraphsSpacing,
                    onChanged: _toggleUseParagraphSpacing,
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
