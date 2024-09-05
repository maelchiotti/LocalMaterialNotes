import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';

/// [SettingsList] with a custom theme applied.
class CustomSettingsList extends StatelessWidget {
  /// Default constructor.
  const CustomSettingsList({
    super.key,
    required this.sections,
  });

  /// Sections of settings to add to this settings list.
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
