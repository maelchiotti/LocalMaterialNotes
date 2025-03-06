import 'package:flutter/material.dart';

import '../../../common/constants/constants.dart';
import '../../../common/extensions/string_extension.dart';
import '../../../common/preferences/preference_key.dart';
import '../widgets/encrypt_password_form.dart';

/// Dialog to configure the manual export.
class ManualExportDialog extends StatefulWidget {
  /// Default constructor.
  const ManualExportDialog({super.key});

  @override
  State<ManualExportDialog> createState() => _ManualExportDialogState();
}

class _ManualExportDialogState extends State<ManualExportDialog> {
  /// Whether to encrypt the export.
  bool _encrypt = PreferenceKey.autoExportEncryption.preferenceOrDefault;

  /// Password to encrypt the export.
  String? _password;

  /// Whether to enable the 'OK' button.
  late bool ok;

  @override
  void initState() {
    super.initState();

    _updateOk();
  }

  /// Updates [ok].
  void _updateOk() {
    ok = !_encrypt || (_encrypt && (_password?.isStrongPassword ?? false));
  }

  /// Updates [_encrypt], [_password] and [ok].
  void _onChanged(bool encrypt, String? password) {
    setState(() {
      _encrypt = encrypt;
      _password = password;
      _updateOk();
    });
  }

  /// Pops the dialog with whether to [_encrypt] and the entered [_password], or nothing if it was [canceled].
  void _pop({bool canceled = false}) {
    if (canceled) {
      Navigator.pop(context);

      return;
    }

    Navigator.pop(context, (_encrypt, _password));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(l.settings_export_json),
      content: SingleChildScrollView(
        child: EncryptPasswordForm(
          secondaryDescription: l.dialog_export_encryption_secondary_description_manual,
          onChanged: _onChanged,
          onEditingComplete: _pop,
        ),
      ),
      actions: [
        TextButton(onPressed: () => _pop(canceled: true), child: Text(fl?.cancelButtonLabel ?? 'Cancel')),
        TextButton(onPressed: ok ? _pop : null, child: Text(fl?.okButtonLabel ?? 'OK')),
      ],
    );
  }
}
