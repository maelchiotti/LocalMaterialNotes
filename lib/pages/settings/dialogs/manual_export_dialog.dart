import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/string_extension.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/widgets/encryption/encrypt_password_form.dart';

class ManualExportDialog extends StatefulWidget {
  const ManualExportDialog({
    super.key,
  });

  @override
  State<ManualExportDialog> createState() => _ManualExportDialogState();
}

class _ManualExportDialogState extends State<ManualExportDialog> {
  bool _encrypt = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();
  String? _password;

  late bool ok;

  @override
  void initState() {
    super.initState();

    _updateOk();
  }

  void _updateOk() {
    ok = !_encrypt || (_encrypt && (_password?.isStrongPassword ?? false));
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

    Navigator.pop(context, (_encrypt, _password));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(localizations.settings_export_json),
      content: SingleChildScrollView(
        child: EncryptionPasswordForm(
          secondaryDescription: localizations.dialog_export_encryption_secondary_description_manual,
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
