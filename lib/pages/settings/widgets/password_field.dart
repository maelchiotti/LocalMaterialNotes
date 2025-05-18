import 'package:flutter/material.dart';

import '../../../common/constants/paddings.dart';
import '../../../common/extensions/build_context_extension.dart';
import '../../../common/extensions/string_extension.dart';

/// Text field to enter the password to use to encrypt the JSON exports.
class PasswordField extends StatefulWidget {
  /// Default constructor.
  const PasswordField({
    super.key,
    this.description,
    this.secondaryDescription,
    required this.onChanged,
    required this.onEditingComplete,
  });

  /// First paragraph of description.
  final String? description;

  /// Second paragraph of description.
  final String? secondaryDescription;

  /// Called when the password has changed.
  final void Function(String? password) onChanged;

  /// Called when the user validates the form.
  final void Function() onEditingComplete;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  /// Whether to obscure the password.
  bool _obscurePassword = true;

  /// Key of the form.
  final _formKey = GlobalKey<FormState>();

  /// Controller of the password text field.
  final _passwordController = TextEditingController();

  /// Toggles whether to [_obscurePassword].
  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  /// Validates the [password].
  ///
  /// The password must be exactly 32 characters long and be strong.
  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return null;
    }

    if (!(password.length == 32) || !password.isStrongPassword) {
      return context.l.dialog_export_encryption_password_invalid;
    }

    return null;
  }

  /// Triggers the [widget.onChanged] callback with the entered password if the form is valid.
  void _onChanged() {
    if (!_formKey.currentState!.validate()) {
      widget.onChanged(null);

      return;
    }

    widget.onChanged(_passwordController.text);
  }

  /// Triggers the [widget.onEditingComplete] callback if the form is valid.
  void _onEditingComplete() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    widget.onEditingComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (widget.description != null) ...[Text(widget.description!), Padding(padding: Paddings.vertical(8))],
          if (widget.secondaryDescription != null) ...[
            Text(widget.secondaryDescription!),
            Padding(padding: Paddings.vertical(8)),
          ],
          AutofillGroup(
            child: TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: _toggleObscurePassword,
                ),
                hintText: context.l.dialog_export_encryption_password,
              ),
              obscureText: _obscurePassword,
              autocorrect: false,
              enableSuggestions: false,
              maxLength: 32,
              validator: _validatePassword,
              onChanged: (_) => _onChanged(),
              onEditingComplete: _onEditingComplete,
            ),
          ),
        ],
      ),
    );
  }
}
