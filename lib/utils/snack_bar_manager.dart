import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

class SnackBarManager {
  SnackBarManager.info(String message) : text = message;

  SnackBarManager.error(String error) : text = '${localizations.error_error}: $error';

  final String text;

  void show() {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
