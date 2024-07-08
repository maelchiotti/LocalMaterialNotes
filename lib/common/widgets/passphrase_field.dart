import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';

class PassphraseField extends StatefulWidget {
  const PassphraseField({
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
  State<PassphraseField> createState() => _PassphraseFieldState();
}

class _PassphraseFieldState extends State<PassphraseField> {
  bool _obscurePassphrase = true;

  final _formKey = GlobalKey<FormState>();
  final _passphraseController = TextEditingController();

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
    if (!_formKey.currentState!.validate()) {
      widget.onChanged(null);

      return;
    }

    widget.onChanged(_passphraseController.text);
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
              controller: _passphraseController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
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
          ),
        ],
      ),
    );
  }
}
