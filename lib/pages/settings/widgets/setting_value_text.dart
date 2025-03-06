import 'package:flutter/material.dart';

import '../../../common/constants/paddings.dart';
import '../../../common/constants/sizes.dart';

/// Body of a navigation setting tile.
///
/// Contains:
///   - The [value] of the setting.
///   - An optional [icon].
///   - An optional [description].
///
/// If the setting tile is not [enabled], the text is shown with a subdued color.
class SettingNavigationTileBody extends StatelessWidget {
  /// Default constructor.
  const SettingNavigationTileBody({super.key, this.enabled = true, required this.value, this.description, this.icon});

  /// Whether the setting tile is disabled.
  final bool enabled;

  /// Value of the setting.
  final String value;

  /// Description of the setting.
  final String? description;

  /// Icon representing the value of the setting.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final titleSmallTextTheme = Theme.of(context).textTheme.titleSmall;
    final tertiaryColor = Theme.of(context).colorScheme.tertiary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: Sizes.settingValueIconSize.size, color: Theme.of(context).colorScheme.tertiary),
              Padding(padding: Paddings.horizontal(2)),
            ],
            Expanded(
              child: Text(
                value,
                style: titleSmallTextTheme?.copyWith(
                  color: enabled ? tertiaryColor : titleSmallTextTheme.color?.withAlpha(100),
                ),
              ),
            ),
          ],
        ),
        if (description != null) Text(description!),
      ],
    );
  }
}
