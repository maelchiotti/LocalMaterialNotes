import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/double_extension.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';

/// Dialog to choose the text scaling.
class TextScalingDialog extends StatefulWidget {
  /// Default constructor.
  const TextScalingDialog({super.key});

  @override
  State<TextScalingDialog> createState() => _TextScalingDialogState();
}

class _TextScalingDialogState extends State<TextScalingDialog> {
  double _textScaling = PreferenceKey.textScaling.getPreferenceOrDefault<double>();

  void _onTextScalingChanged(double value) {
    setState(() {
      _textScaling = value;
    });
  }

  /// Pops the dialog with the chosen [_frequencyValue], or nothing if it was [canceled].
  void _pop({bool canceled = false}) {
    if (canceled) {
      Navigator.pop(context);

      return;
    }

    Navigator.pop(context, _textScaling);
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
              value: _textScaling,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              label: _textScaling.formatedAsPercentage(locale: LocaleUtils().appLocale),
              onChanged: _onTextScalingChanged,
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
