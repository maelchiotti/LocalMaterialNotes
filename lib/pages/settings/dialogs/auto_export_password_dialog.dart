import 'package:flutter/material.dart';
import '../../../common/constants/constants.dart';
import '../../../common/extensions/string_extension.dart';
import '../widgets/password_field.dart';

/// Dialog to enter the password for the auto exports.
class AutoExportPasswordDialog extends StatefulWidget {
  /// Default constructor.
  const AutoExportPasswordDialog({
    super.key,
    required this.title,
    required this.description,
    this.secondaryDescription,
  });

  /// Title of the dialog.
  final String title;

  /// First paragraph of description to show above the password field.
  final String description;

  /// Second paragraph of description to show above the password field.
  final String? secondaryDescription;

  @override
  State<AutoExportPasswordDialog> createState() => _AutoExportPasswordDialogState();
}

class _AutoExportPasswordDialogState extends State<AutoExportPasswordDialog> {
  /// Password used for the encryption.
  String? _password;

  /// Whether the dialog can be validated, and thus whether the 'Ok' button can be enabled
  late bool ok;

  @override
  void initState() {
    super.initState();

    _updateOk();
  }

  /// Updates whether the 'Ok' button can be enabled.
  void _updateOk() {
    ok = _password?.isStrongPassword ?? false;
  }

  /// Updates the [value] of the [_password].
  void _onChanged(String? value) {
    setState(() {
      _password = value;
      _updateOk();
    });
  }

  /// Pops the dialog with the entered [_password], or nothing if it was [canceled].
  void _pop({bool canceled = false}) {
    if (canceled) {
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
          description: widget.description,
          secondaryDescription: widget.secondaryDescription,
          onChanged: _onChanged,
          onEditingComplete: _pop,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _pop(canceled: true),
          child: Text(flutterL?.cancelButtonLabel ?? 'Cancel'),
        ),
        TextButton(
          onPressed: ok ? _pop : null,
          child: Text(flutterL?.okButtonLabel ?? 'OK'),
        ),
      ],
    );
  }
}
