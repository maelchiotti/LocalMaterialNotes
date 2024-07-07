import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

class PassphraseForm extends StatefulWidget {
  const PassphraseForm({
    super.key,
    required this.onChanged,
    required this.onEditingComplete,
  });

  final Function(bool, String) onChanged;
  final Function() onEditingComplete;

  @override
  State<PassphraseForm> createState() => _PassphraseFormState();
}

class _PassphraseFormState extends State<PassphraseForm> {
  bool _encrypt = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();
  bool _obscurePassphrase = true;

  final _formKey = GlobalKey<FormState>();
  final _passphraseController = TextEditingController();

  void _toggleEncrypt(_) {
    setState(() {
      _encrypt = !_encrypt;
    });

    _onChanged();
  }

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassphrase = !_obscurePassphrase;
    });
  }

  String? _validatePassphrase(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!(value.length == 32) || !value.isStrongPassword) {
      return localizations.dialog_export_encryption_passphrase_invalid;
    }

    return null;
  }

  void _onChanged() {
    if (!_encrypt || (_encrypt && !_formKey.currentState!.validate())) {
      widget.onChanged(_encrypt, '');

      return;
    }

    widget.onChanged(_encrypt, _passphraseController.text);
  }

  void _onEditingComplete() {
    if (_encrypt && !_formKey.currentState!.validate()) {
      return;
    }

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
        Form(
          key: _formKey,
          child: Visibility(
            visible: _encrypt,
            child: Column(
              children: [
                Padding(padding: Paddings.padding8.vertical),
                Text(localizations.dialog_export_encryption_description),
                Padding(padding: Paddings.padding8.vertical),
                TextFormField(
                  controller: _passphraseController,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassphrase ? Icons.visibility : Icons.visibility_off),
                      onPressed: _toggleObscurePassword,
                    ),
                    hintText: localizations.dialog_export_encryption_passphrase_hint,
                  ),
                  obscureText: _obscurePassphrase,
                  autocorrect: false,
                  enableSuggestions: false,
                  maxLength: 32,
                  validator: _validatePassphrase,
                  onChanged: (_) => _onChanged(),
                  onEditingComplete: _onEditingComplete,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
