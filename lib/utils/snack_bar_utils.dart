import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';

/// Utilities for the snack bars.
class SnackBarUtils {
  /// A snack bar that holds an informative [message].
  SnackBarUtils.info(
    String message, {
    this.duration = const Duration(milliseconds: 4000),
  }) : text = message;

  /// A snack bar that holds an [error] message.
  ///
  /// The message is prefixed with the string `Error: `. Thus, the message should start with a lowercase.
  SnackBarUtils.error(
    String error, {
    this.duration = const Duration(milliseconds: 4000),
  }) : text = '${l.error_snack_bar} $error';

  /// Text to display in the snack bar;
  final String text;

  /// Duration of the snack bar.
  final Duration duration;

  /// Shows the snack bar.
  void show({BuildContext? context}) {
    ScaffoldMessenger.of(context ?? rootNavigatorKey.currentContext!).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: duration,
        content: Text(text),
      ),
    );
  }
}
