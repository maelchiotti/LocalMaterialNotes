import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/widgets/passphrase_field.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

class EncryptionPassphraseForm extends StatefulWidget {
  const EncryptionPassphraseForm({
    super.key,
    required this.secondaryDescription,
    required this.onChanged,
    required this.onEditingComplete,
  });

  final String secondaryDescription;

  final Function(bool, String?) onChanged;
  final Function() onEditingComplete;

  @override
  State<EncryptionPassphraseForm> createState() => _EncryptionPassphraseFormState();
}

class _EncryptionPassphraseFormState extends State<EncryptionPassphraseForm> {
  bool _encrypt = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();

  void _toggleEncrypt(_) {
    setState(() {
      _encrypt = !_encrypt;
    });

    _onChanged(null);
  }

  void _onChanged(String? passphrase) {
    widget.onChanged(_encrypt, passphrase);
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
          PassphraseField(
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
