import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

import '../../../common/extensions/build_context_extension.dart';

/// Dialog to add a link in the editor.
class ToolbarLinkDialog extends StatefulWidget {
  /// Default constructor.
  const ToolbarLinkDialog({super.key});

  @override
  State<ToolbarLinkDialog> createState() => _ToolbarLinkDialogState();
}

class _ToolbarLinkDialogState extends State<ToolbarLinkDialog> {
  /// Controller for the link text field.
  final _linkController = TextEditingController();

  /// Whether the link is a valid URL.
  var _isLinkValid = false;

  /// Update [_isLinkValid] when the link has changed.
  void _onChanged(_) {
    setState(() {
      _isLinkValid = isURL(_linkController.text, {
        'protocols': ['http', 'https'],
        'require_tld': true,
        'require_protocol': true,
        'allow_underscores': false,
      });
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
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(context.l.dialog_add_link),
      content: TextField(
        controller: _linkController,
        autofocus: true,
        decoration: InputDecoration(labelText: context.l.hint_link),
        onChanged: _onChanged,
      ),
      actions: [
        TextButton(onPressed: () => _pop(canceled: true), child: Text(context.fl.cancelButtonLabel)),
        TextButton(onPressed: _isLinkValid ? _pop : null, child: Text(context.fl.okButtonLabel)),
      ],
    );
  }
}
