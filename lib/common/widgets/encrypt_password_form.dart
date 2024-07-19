import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/widgets/password_field.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

class EncryptionPasswordForm extends StatefulWidget {
  const EncryptionPasswordForm({
    super.key,
    required this.secondaryDescription,
    required this.onChanged,
    required this.onEditingComplete,
  });

  final String secondaryDescription;

  final Function(bool, String?) onChanged;
  final Function() onEditingComplete;

  @override
  State<EncryptionPasswordForm> createState() => _EncryptionPasswordFormState();
}

class _EncryptionPasswordFormState extends State<EncryptionPasswordForm> {
  bool _encrypt = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();

  void _toggleEncrypt(_) {
    setState(() {
      _encrypt = !_encrypt;
    });

    _onChanged(null);
  }

  void _onChanged(String? password) {
    widget.onChanged(_encrypt, password);
  }

  void _onEditingComplete() {
    widget.onEditingComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(localizations.dialog_export_encryption_switch),
            ),
            Switch(
              value: _encrypt,
              onChanged: _toggleEncrypt,
            ),
          ],
        ),
        if (_encrypt) ...[
          Padding(padding: Paddings.padding8.vertical),
          PasswordField(
            description: localizations.dialog_export_encryption_description,
            secondaryDescription: widget.secondaryDescription,
            onChanged: _onChanged,
            onEditingComplete: _onEditingComplete,
          ),
        ],
      ],
    );
  }
}
