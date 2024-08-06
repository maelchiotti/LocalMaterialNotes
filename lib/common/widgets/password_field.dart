import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.description,
    this.secondaryDescription,
    required this.onChanged,
    required this.onEditingComplete,
  });

  final String? description;
  final String? secondaryDescription;

  final Function(String?) onChanged;
  final Function() onEditingComplete;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscurePassword = true;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!(value.length == 32) || !value.isStrongPassword) {
      return localizations.dialog_export_encryption_password_invalid;
    }

    return null;
  }

  void _onChanged() {
    if (!_formKey.currentState!.validate()) {
      widget.onChanged(null);

      return;
    }

    widget.onChanged(_passwordController.text);
  }

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
          if (widget.description != null) ...[
            Text(widget.description!),
            Padding(padding: Paddings.padding8.vertical),
          ],
          if (widget.secondaryDescription != null) ...[
            Text(widget.secondaryDescription!),
            Padding(padding: Paddings.padding8.vertical),
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
                hintText: localizations.dialog_export_encryption_password_hint,
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
