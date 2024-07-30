import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';

class CustomSettingsList extends StatelessWidget {
  const CustomSettingsList({
    super.key,
    required this.sections,
  });

  final List<SettingsSection> sections;

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
      sections: sections,
    );
  }
}
