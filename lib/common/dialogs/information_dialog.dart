import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

Future<void> showInformationDialog(
  BuildContext context,
  String title,
  String body,
) async {
  showAdaptiveDialog(
    context: context,
    builder: (context) {
      return AlertDialog.adaptive(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations.button_close),
          ),
        ],
      );
    },
  );
}
