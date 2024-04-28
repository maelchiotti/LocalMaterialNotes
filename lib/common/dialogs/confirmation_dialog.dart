import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/confirmations.dart';

Future<bool> showConfirmationDialog(
  BuildContext context,
  String title,
  String body,
  String confirmText, {
  bool? irreversible,
}) async {
  if (irreversible != null) {
    final confirmationsPreference = Confirmations.fromPreference();

    return confirmationsPreference == Confirmations.none ||
        (confirmationsPreference == Confirmations.irreversible && !irreversible);
  }

  return await showAdaptiveDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(body),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(localizations.button_cancel),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(confirmText),
              ),
            ],
          );
        },
      ) ??
      false;
}
