import 'package:flutter/material.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/preferences/preference_key.dart';

/// Lock delay setting dialog.
class LockDelayDialog extends StatefulWidget {
  /// Setting dialog to choose after which time the application should be locked if the application lock is enabled.
  ///
  /// This is used instead of a [SettingSliderTile] to use custom values for the slider.
  const LockDelayDialog({super.key});

  @override
  State<LockDelayDialog> createState() => _LockDelayDialogState();
}

class _LockDelayDialogState extends State<LockDelayDialog> {
  /// The index of the current delay value in [values].
  late int index;

  /// The allowed delay values.
  final values = [0, 3, 5, 10, 30, 60, 120, 300, 999];

  /// Returns the current delay value.
  int get value => values[index];

  @override
  void initState() {
    super.initState();

    final delayPreference = PreferenceKey.lockAppDelay.preferenceOrDefault;
    final delayIndex = values.indexOf(delayPreference);

    if (delayIndex == -1) {
      throw Exception("Delay preference isn't one of the allowed values: $delayIndex");
    }

    index = delayIndex;
  }

  /// Updates the [value] of the current [index].
  void onValueChanged(double value) {
    setState(() {
      index = value.toInt();
    });
  }

  /// Pops the dialog with the chosen [value], or nothing if it was [canceled].
  void pop({bool canceled = false}) {
    if (canceled) {
      Navigator.pop(context);

      return;
    }

    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(l.settings_application_lock_delay_title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: index.toDouble(),
              max: values.length - 1,
              divisions: values.length - 1,
              label: value.toString(),
              onChanged: onValueChanged,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => pop(canceled: true),
          child: Text(flutterL?.cancelButtonLabel ?? 'Cancel'),
        ),
        TextButton(
          onPressed: pop,
          child: Text(flutterL?.okButtonLabel ?? 'OK'),
        ),
      ],
    );
  }
}
