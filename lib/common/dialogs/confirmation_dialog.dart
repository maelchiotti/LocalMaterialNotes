import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/confirmations.dart';

Future<bool> _showConfirmationDialog(
  String title,
  String body,
  String confirmText,
) async {
  return await showAdaptiveDialog<bool>(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog.adaptive(
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
                onPressed: () => Navigator.pop(context, false),
                child: Text(localizations.button_cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmText),
              ),
            ],
          );
        },
      ) ??
      false;
}

Future<bool> askForConfirmation(
  String title,
  String body,
  String confirmText, {
  bool irreversible = false,
}) async {
  final confirmationsPreference = Confirmations.fromPreference();

  switch (confirmationsPreference) {
    case Confirmations.none:
      return true;
    case Confirmations.irreversible:
      if (irreversible) {
        return _showConfirmationDialog(title, body, confirmText);
      } else {
        return true;
      }
    case Confirmations.all:
      return _showConfirmationDialog(title, body, confirmText);
  }
}
