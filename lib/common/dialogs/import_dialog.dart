import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/widgets/passphrase_field.dart';
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
  String? _passphrase;

  late bool ok;

  @override
  void initState() {
    super.initState();

    _updateOk();
  }

  void _updateOk() {
    ok = _passphrase?.isStrongPassword ?? false;
  }

  void _onChanged(String? passphrase) {
    setState(() {
      _passphrase = passphrase;
      _updateOk();
    });
  }

  void _pop({bool cancel = false}) {
    if (cancel) {
      Navigator.pop(context);

      return;
    }

    Navigator.pop(context, _passphrase);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: PassphraseField(
          description: localizations.dialog_import_encryption_passphrase_description,
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
