import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/preferences/enums/confirmations.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Shows the confirmation dialog to ask the user for a confirmation on an action.
///
/// Returns `true` if the user confirms the action, `false` otherwise.
///
/// The [title], [body] and [confirmText] depend on the action for which the confirmation must be obtained.
Future<bool> _showConfirmationDialog(
  BuildContext context,
  String title,
  String body,
  String confirmText,
) async {
  return await showAdaptiveDialog<bool>(
        context: context,
        useRootNavigator: false,
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
                key: Keys.dialogCancelButton,
                onPressed: () => Navigator.pop(context, false),
                child: Text(flutterL?.okButtonLabel ?? 'OK'),
              ),
              TextButton(
                key: Keys.dialogConfirmButton,
                onPressed: () => Navigator.pop(context, true),
                child: Text(confirmText),
              ),
            ],
          );
        },
      ) ??
      false;
}

/// Asks the user for a confirmation on an action.
///
/// Returns `true` if the confirmation is not needed according to the user settings, without showing
/// the confirmation dialog. If the confirmation is needed, returns `true` if the user confirms the action,
/// `false` otherwise.
///
/// The [title], [body] and [confirmText] depend on the action for which the confirmation must be obtained.
///
/// An action is [irreversible] if its consequences cannot be reversed, such as permanently deleting a note
/// or emptying the bin.
Future<bool> askForConfirmation(
  BuildContext context,
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
        return _showConfirmationDialog(context, title, body, confirmText);
      } else {
        return true;
      }
    case Confirmations.all:
      return _showConfirmationDialog(context, title, body, confirmText);
  }
}
