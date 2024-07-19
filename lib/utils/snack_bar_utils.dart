import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

class SnackBarUtils {
  SnackBarUtils.info(
    String message, {
    this.duration = const Duration(seconds: 4),
  }) : text = message;

  SnackBarUtils.error(
    String error, {
    this.duration = const Duration(seconds: 4),
  }) : text = '${localizations.error_error}: $error';

  final String text;
  final Duration duration;

  void show({BuildContext? context}) {
    ScaffoldMessenger.of(context ?? navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration,
        content: Text(text),
      ),
    );
  }
}
