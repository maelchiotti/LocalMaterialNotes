import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

class AutoExportFrequencyDialog extends StatefulWidget {
  @override
  State<AutoExportFrequencyDialog> createState() => _AutoExportFrequencyDialogState();
}

class _AutoExportFrequencyDialogState extends State<AutoExportFrequencyDialog> {
  double frequency = PreferenceKey.autoExportFrequency.getPreferenceOrDefault<double>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(localizations.settings_auto_export),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            frequency == 0
                ? localizations.settings_auto_export_dialog_content_disabled
                : localizations.settings_auto_export_dialog_content_enabled(frequency.toInt().toString()),
          ),
          Padding(padding: Paddings.padding8.vertical),
          Slider(
            value: frequency,
            max: 30.0,
            divisions: 30,
            label: frequency == 0
                ? localizations.settings_auto_export_disabled
                : localizations.settings_auto_export_value(frequency.toInt().toString()),
            onChanged: (value) {
              setState(() {
                frequency = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(localizations.button_cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, frequency),
          child: Text(localizations.button_ok),
        ),
      ],
    );
  }
}
