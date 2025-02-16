import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants.dart';

/// Utilities for the snack bars.
///
/// This class is a singleton.
class SnackBarUtils {
  static final SnackBarUtils _singleton = SnackBarUtils._internal();

  /// Default constructor.
  factory SnackBarUtils() => _singleton;

  SnackBarUtils._internal();

  /// Global [WidgetRef] from used to access the providers even after a page has been removed from the widget tree.
  late final WidgetRef globalRef;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized(WidgetRef ref) async {
    globalRef = ref;
  }

  /// Shows a snack bar with the [text].
  ///
  /// If [context] is `null`, the current context of [rootNavigatorKey] is used instead.
  ///
  /// if [error] is `true`, the [text] is prefixed with `Error:`.
  ///
  /// If [onCancel] is set, an action that calls it when tapped is shown.
  void show({
    BuildContext? context,
    required String text,
    bool error = false,
    void Function(WidgetRef globalRef)? onCancel,
  }) {
    if (error) {
      text = '${l.error_snack_bar} $text';
    }

    context ??= rootNavigatorKey.currentContext!;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        action: onCancel != null
            ? SnackBarAction(
                label: flutterL?.cancelButtonLabel ?? 'Cancel',
                onPressed: () => onCancel(globalRef),
              )
            : null,
      ),
    );
  }
}
