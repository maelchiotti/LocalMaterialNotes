import 'package:flutter/material.dart';

import '../../../common/constants/paddings.dart';
import '../../../common/extensions/build_context_extension.dart';
import '../../../common/preferences/preference_key.dart';
import 'password_field.dart';

/// Form to choose whether to encrypt the JSON exports and to provide the password.
class EncryptPasswordForm extends StatefulWidget {
  /// Default constructor.
  const EncryptPasswordForm({
    super.key,
    required this.secondaryDescription,
    required this.onChanged,
    required this.onEditingComplete,
  });

  /// Second paragraph of description to show above the password field.
  final String secondaryDescription;

  /// Called when the text has changed in the password field.
  ///
  /// Returns whether to [encrypt] the JSON export, and in that case the [password] to use.
  final void Function(bool encrypt, String? password) onChanged;

  /// Called when the user validates the form.
  final void Function() onEditingComplete;

  @override
  State<EncryptPasswordForm> createState() => _EncryptPasswordFormState();
}

class _EncryptPasswordFormState extends State<EncryptPasswordForm> {
  /// Whether the JSON export should be encrypted.
  bool _encrypt = PreferenceKey.autoExportEncryption.preferenceOrDefault;

  /// Toggles whether to [_encrypt] the JSON export.
  void _toggleEncrypt(_) {
    setState(() {
      _encrypt = !_encrypt;
    });

    _onChanged(null);
  }

  /// Triggers the [widget.onChanged] callback.
  void _onChanged(String? password) {
    widget.onChanged(_encrypt, password);
  }

  /// Triggers the [widget.onEditingComplete] callback.
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
            Expanded(child: Text(context.l.dialog_export_encryption_switch)),
            Switch(value: _encrypt, onChanged: _toggleEncrypt),
          ],
        ),
        if (_encrypt) ...[
          Padding(padding: Paddings.vertical(8)),
          PasswordField(
            description: context.l.dialog_export_encryption_description,
            secondaryDescription: widget.secondaryDescription,
            onChanged: _onChanged,
            onEditingComplete: _onEditingComplete,
          ),
        ],
      ],
    );
  }
}
