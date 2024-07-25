import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/pages/settings/sections/about_section.dart';
import 'package:localmaterialnotes/pages/settings/sections/appearance_section.dart';
import 'package:localmaterialnotes/pages/settings/sections/backup_section.dart';
import 'package:localmaterialnotes/pages/settings/sections/behavior_section.dart';
import 'package:localmaterialnotes/pages/settings/sections/editor_section.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage();

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  void _updateState() {
    setState(() {
      // Update the settings screen to update the tile that was changed.
    });
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      platform: DevicePlatform.android,
      contentPadding: Paddings.custom.bottomSystemUi,
      lightTheme: SettingsThemeData(
        settingsListBackground: Theme.of(context).colorScheme.surface,
      ),
      darkTheme: SettingsThemeData(
        settingsListBackground: Theme.of(context).colorScheme.surface,
      ),
      sections: [
        AppearanceSection(_updateState),
        EditorSection(_updateState),
        BehaviorSection(_updateState),
        BackupSection(ref, _updateState),
        const AboutSection(),
      ],
    );
  }
}
