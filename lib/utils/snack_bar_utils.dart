import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

class SnackBarUtils {
  SnackBarUtils.info(String message) : text = message;

  SnackBarUtils.error(String error) : text = '${localizations.error_error}: $error';

  final String text;

  void show({BuildContext? context}) {
    ScaffoldMessenger.of(context ?? navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
      ),
    );
  }
}
