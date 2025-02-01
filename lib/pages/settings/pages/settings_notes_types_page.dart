import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/preferences/watched_preferences.dart';
import '../../../common/widgets/keys.dart';
import '../../../models/note/notes_types.dart';
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
  }

  /// Sets the setting for the default shortcut note type to [defaultShortcutNoteType].
  void onSubmittedDefaultShortcutNoteType(NoteType defaultShortcutNoteType) {
    setState(() {
      PreferenceKey.defaultShortcutNoteType.set(defaultShortcutNoteType.name);
    });
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

    final shortcutNotesTypes = NoteType.shortcutTypes.map((type) {
      return (value: type, title: type.title, subtitle: null);
    }).toList();
    final defaultShortcutNoteType = NoteType.defaultShortcutType;

    return Scaffold(
      appBar: TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar(title: l.navigation_settings_notes_types),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                tiles: [
                  SettingMultipleOptionsTile.detailed(
                    icon: Icons.edit_note,
                    title: 'Available notes types',
                    value: availableNotesTypesString,
                    description:
                        'The list of notes types that can be created, either from the notes page or with a shortcut. When removing a type, already existing notes with that type are not deleted and can still be used normally.',
                    dialogTitle: 'Available notes types',
                    options: notesTypes,
                    initialOptions: availableNotesTypes,
                    minOptions: 1,
                    onSubmitted: onSubmittedAvailableNotesTypes,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.app_shortcut,
                    title: 'Default shortcut type',
                    value: defaultShortcutNoteType.title,
                    description: 'The default note type to use when creating a note from a shortcut',
                    dialogTitle: 'Default shortcut type',
                    options: shortcutNotesTypes,
                    initialOption: defaultShortcutNoteType,
                    onSubmitted: onSubmittedDefaultShortcutNoteType,
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
