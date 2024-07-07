import 'package:flutter/material.dart';
import 'package:localmaterialnotes/pages/settings/passphrase_form.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

class ExportAsJsonDialog extends StatefulWidget {
  @override
  State<ExportAsJsonDialog> createState() => _ExportAsJsonDialogState();
}

class _ExportAsJsonDialogState extends State<ExportAsJsonDialog> {
  bool _encrypt = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();
  String _passphrase = '';

  late bool ok;

  @override
  void initState() {
    super.initState();

    ok = !_encrypt || (_encrypt && _passphrase.isNotEmpty);
  }

  void _onChanged(bool encrypt, String passphrase) {
    setState(() {
      _encrypt = encrypt;
      _passphrase = passphrase;
      ok = !_encrypt || (_encrypt && _passphrase.isNotEmpty);
    });
  }

  void _pop({bool cancel = false}) {
    if (cancel) {
      Navigator.pop(context);

      return;
    }

    Navigator.pop(context, (_encrypt, _passphrase));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(localizations.settings_export_json),
      content: SingleChildScrollView(
        child: PassphraseForm(
          onChanged: _onChanged,
          onEditingComplete: _pop,
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
