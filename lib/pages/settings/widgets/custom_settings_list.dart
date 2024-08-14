import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';

class CustomSettingsList extends StatelessWidget {
  const CustomSettingsList({
    super.key,
    required this.sections,
  });

  final List<SettingsSection> sections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsList(
      platform: DevicePlatform.android,
      contentPadding: Paddings.custom.bottomSystemUi,
      lightTheme: SettingsThemeData(
        settingsListBackground: theme.colorScheme.surface,
        titleTextColor: theme.textTheme.bodyMedium?.color,
      ),
      darkTheme: SettingsThemeData(
        settingsListBackground: theme.colorScheme.surface,
        titleTextColor: theme.textTheme.bodyMedium?.color,
      ),
      sections: sections,
    );
  }
}
