import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/widgets/encrypt_password_form.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

class AutoExportDialog extends StatefulWidget {
  const AutoExportDialog({super.key});

  @override
  State<AutoExportDialog> createState() => _AutoExportDialogState();
}

class _AutoExportDialogState extends State<AutoExportDialog> {
  bool _encrypt = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();
  String? _password;

  late bool ok;
  late int _frequencyIndex;

  final List<double> _frequencyValues = [0.0, 1.0, 3.0, 7.0, 14.0, 30.0];

  @override
  void initState() {
    super.initState();

    _frequencyIndex = _frequencyValues.indexOf(PreferenceKey.autoExportFrequency.getPreferenceOrDefault<double>());
    if (_frequencyIndex == -1) {
      // Make sure that the index is not set to -1 in case the frequency isn't in the allowed values
      _frequencyIndex = 0;
    }

    _updateOk();
  }

  double get _frequencyValue {
    return _frequencyValues[_frequencyIndex];
  }

  void _updateOk() {
    ok = _frequencyValue == 0.0 || !_encrypt || (_encrypt && (_password?.isStrongPassword ?? false));
  }

  void _onFrequencyChanged(double value) {
    setState(() {
      _frequencyIndex = value.toInt();
      _updateOk();
    });
  }

  void _onChanged(bool encrypt, String? password) {
    setState(() {
      _encrypt = encrypt;
      _password = password;
      _updateOk();
    });
  }

  void _pop({bool cancel = false}) {
    if (cancel) {
      Navigator.pop(context);

      return;
    }

    Navigator.pop(context, (_frequencyValue, _encrypt, _password));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(localizations.settings_auto_export),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _frequencyValue == 0.0
                  ? localizations.settings_auto_export_dialog_description_disabled
                  : localizations.settings_auto_export_dialog_description_enabled(_frequencyValue.toInt().toString()),
            ),
            Padding(padding: Paddings.padding8.vertical),
            Slider(
              value: _frequencyIndex.toDouble(),
              max: _frequencyValues.length - 1,
              divisions: _frequencyValues.length - 1,
              label: _frequencyValue == 0.0
                  ? localizations.settings_auto_export_disabled
                  : localizations.settings_auto_export_dialog_slider_label(_frequencyValue.toInt().toString()),
              onChanged: _onFrequencyChanged,
            ),
            if (_frequencyValue != 0.0) ...[
              Padding(padding: Paddings.padding8.vertical),
              EncryptionPasswordForm(
                secondaryDescription: localizations.dialog_export_encryption_secondary_description_auto,
                onChanged: _onChanged,
                onEditingComplete: _pop,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _pop(cancel: true),
          child: Text(localizations.button_cancel),
        ),
        TextButton(
          onPressed: ok ? _pop : null,
          child: Text(localizations.button_ok),
        ),
      ],
    );
  }
}
