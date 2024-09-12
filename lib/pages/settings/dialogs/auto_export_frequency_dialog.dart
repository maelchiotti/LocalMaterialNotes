import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';

/// Dialog to choose the frequency of the auto export.
class AutoExportFrequencyDialog extends StatefulWidget {
  /// Default constructor.
  const AutoExportFrequencyDialog({super.key});

  @override
  State<AutoExportFrequencyDialog> createState() => _AutoExportFrequencyDialogState();
}

class _AutoExportFrequencyDialogState extends State<AutoExportFrequencyDialog> {
  /// Index of the current frequency value in [_frequencyValues].
  late int _frequencyIndex;

  /// Allowed frequency values.
  final _frequencyValues = [1, 3, 7, 14, 30];

  /// Current frequency value.
  int get _frequencyValue {
    return _frequencyValues[_frequencyIndex];
  }

  @override
  void initState() {
    super.initState();

    final frequencyPreference = PreferenceKey.autoExportFrequency.getPreferenceOrDefault<int>();
    final frequencyIndex = _frequencyValues.indexOf(frequencyPreference);

    if (frequencyIndex == -1) {
      throw Exception("Frequency preference isn't one of the allowed values: $frequencyIndex");
    }

    _frequencyIndex = frequencyIndex;
  }

  /// Updates the [value] of the current [_frequencyIndex].
  void _onFrequencyChanged(double value) {
    setState(() {
      _frequencyIndex = value.toInt();
    });
  }

  /// Pops the dialog with the chosen [_frequencyValue], or nothing if it was [canceled].
  void _pop({bool canceled = false}) {
    if (canceled) {
      Navigator.pop(context);

      return;
    }

    Navigator.pop(context, _frequencyValue);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(localizations.settings_auto_export_frequency),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: _frequencyIndex.toDouble(),
              max: _frequencyValues.length - 1,
              divisions: _frequencyValues.length - 1,
              label: localizations.dialog_auto_export_frequency_slider_label(_frequencyValue.toString()),
              onChanged: _onFrequencyChanged,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _pop(canceled: true),
          child: Text(localizations.button_cancel),
        ),
        TextButton(
          onPressed: _pop,
          child: Text(localizations.button_ok),
        ),
      ],
    );
  }
}
