import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/preferences/watched_preferences.dart';
import '../../../models/note/notes_types.dart';
import '../../../providers/preferences/preferences_provider.dart';
import '../../../utils/keys.dart';

/// Notes types settings.
class SettingsNotesTypesPage extends ConsumerStatefulWidget {
  /// Settings page related to the notes types.
  const SettingsNotesTypesPage({super.key});

  @override
  ConsumerState<SettingsNotesTypesPage> createState() => _SettingsNotesTypesPageState();
}

class _SettingsNotesTypesPageState extends ConsumerState<SettingsNotesTypesPage> {
  /// Sets the setting for the available notes types to [availableNotesTypes].
  void _onSubmittedAvailableNotesTypes(List<Type> availableNotesTypes) {
    PreferenceKey.availableNotesTypes.set(NotesTypes.toPreference(availableNotesTypes));

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(availableNotesTypes: availableNotesTypes));
  }

  @override
  Widget build(BuildContext context) {
    final allNotesTypes = NotesTypes.all();
    final availableNotesTypes = ref.watch(
      preferencesProvider.select((preferences) => preferences.availableNotesTypes),
    );
    final availableNotesTypesString = NotesTypes.fromPreferenceAsString();

    return Scaffold(
      appBar: TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar(
          title: l.navigation_settings_notes_tiles,
          //back: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                tiles: [
                  SettingMultipleOptionsTile<Type>.detailed(
                    icon: Icons.edit_note,
                    title: 'Available notes types',
                    value: availableNotesTypesString,
                    description:
                        'The list of notes types that can be created, either from the notes page or with a shortcut. When removing a type, already existing notes with that type are not deleted and can still be used normally.',
                    dialogTitle: 'Available notes types',
                    options: allNotesTypes,
                    initialOptions: availableNotesTypes,
                    minOptions: 1,
                    onSubmitted: _onSubmittedAvailableNotesTypes,
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
