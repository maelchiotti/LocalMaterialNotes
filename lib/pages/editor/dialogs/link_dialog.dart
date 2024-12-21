import 'package:flutter/material.dart';
import '../../../common/constants/constants.dart';
import 'package:string_validator/string_validator.dart';

/// Dialog to add a link in the editor.
class LinkDialog extends StatefulWidget {
  /// Default constructor.
  const LinkDialog({super.key});

  @override
  State<LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<LinkDialog> {
  /// Controller for the link text field.
  final _linkController = TextEditingController();

  /// Whether the link is a valid URL.
  var _isLinkValid = false;

  /// Update [_isLinkValid] when the link has changed.
  void _onChanged(_) {
    setState(() {
      _isLinkValid = isURL(_linkController.text);
    });
  }

  /// Pops the dialog with the entered link, or nothing if it was [canceled].
  void _pop({bool canceled = false}) {
    if (canceled) {
      Navigator.pop(context);

      return;
    }

    Navigator.pop(context, _linkController.text);
  }

  @override
  Widget build(BuildContext context) => AlertDialog.adaptive(
        title: Text(l.dialog_add_link),
        content: TextField(
          controller: _linkController,
          autofocus: true,
          decoration: InputDecoration(
            labelText: l.hint_link,
          ),
          onChanged: _onChanged,
        ),
        actions: [
          TextButton(
            onPressed: () => _pop(canceled: true),
            child: Text(flutterL?.cancelButtonLabel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: _isLinkValid ? _pop : null,
            child: Text(flutterL?.okButtonLabel ?? 'OK'),
          ),
        ],
      );
}
