import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';

/// Body of a navigation setting tile showing the [value] of the setting with its optional [icon]
/// and an optional [description].
class SettingNavigationTileBody extends StatelessWidget {
  /// Default constructor.
  const SettingNavigationTileBody({
    super.key,
    required this.value,
    this.description,
    this.icon,
  });

  /// Value of the setting.
  final String value;

  /// Description of the setting.
  final String? description;

  /// Icon representing the value of the setting.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: Sizes.settingValueIconSize.size,
                color: Theme.of(context).colorScheme.tertiary,
              ),
              Padding(padding: Paddings.horizontal(2)),
            ],
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          ],
        ),
        if (description != null) Text(description!),
      ],
    );
  }
}
