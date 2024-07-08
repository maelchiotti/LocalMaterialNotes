import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/widgets/encrypt_passphrase_form.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

class AutoExportDialog extends StatefulWidget {
  const AutoExportDialog({super.key});

  @override
  State<AutoExportDialog> createState() => _AutoExportDialogState();
}

class _AutoExportDialogState extends State<AutoExportDialog> {
  double _frequency = PreferenceKey.autoExportFrequency.getPreferenceOrDefault<double>();

  bool _encrypt = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();
  String? _passphrase;

  late bool ok;

  @override
  void initState() {
    super.initState();

    ok = !_encrypt || (_encrypt && _passphrase != null && _passphrase!.isNotEmpty);
  }

  void _onChanged(bool encrypt, String? passphrase) {
    setState(() {
      _encrypt = encrypt;
      _passphrase = passphrase;
      ok = !_encrypt || (_encrypt && _passphrase != null && _passphrase!.isNotEmpty);
    });
  }

  void _pop({bool cancel = false}) {
    if (cancel) {
      Navigator.pop(context);

      return;
    }

    Navigator.pop(context, (_frequency, _encrypt, _passphrase));
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
              _frequency == 0
                  ? localizations.settings_auto_export_dialog_description_disabled
                  : localizations.settings_auto_export_dialog_description_enabled(_frequency.toInt().toString()),
            ),
            Padding(padding: Paddings.padding8.vertical),
            Slider(
              value: _frequency,
              max: 30.0,
              divisions: 30,
              label: _frequency == 0
                  ? localizations.settings_auto_export_disabled
                  : localizations.settings_auto_export_dialog_slider_label(_frequency.toInt().toString()),
              onChanged: (value) {
                setState(() {
                  _frequency = value;
                });
              },
            ),
            Padding(padding: Paddings.padding8.vertical),
            EncryptionPassphraseForm(
              secondaryDescription: localizations.dialog_export_encryption_secondary_description_auto,
              onChanged: _onChanged,
              onEditingComplete: _pop,
            ),
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
