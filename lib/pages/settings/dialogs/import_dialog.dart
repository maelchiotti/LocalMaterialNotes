import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/widgets/encryption/password_field.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/string_extension.dart';

class ImportDialog extends StatefulWidget {
  const ImportDialog({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<ImportDialog> createState() => _ImportDialogState();
}

class _ImportDialogState extends State<ImportDialog> {
  String? _password;

  late bool ok;

  @override
  void initState() {
    super.initState();

    _updateOk();
  }

  void _updateOk() {
    ok = _password?.isStrongPassword ?? false;
  }

  void _onChanged(String? password) {
    setState(() {
      _password = password;
      _updateOk();
    });
  }

  void _pop({bool cancel = false}) {
    if (cancel) {
      Navigator.pop(context);

      return;
    }

    Navigator.pop(context, _password);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: PasswordField(
          description: localizations.dialog_import_encryption_password_description,
          secondaryDescription: localizations.dialog_export_encryption_description,
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
