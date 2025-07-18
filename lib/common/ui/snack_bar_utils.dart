import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/note/types/note_type.dart';
import '../constants/constants.dart';
import '../extensions/build_context_extension.dart';

/// Utilities for the snack bars.
class SnackBarUtils {
  /// Shows a snack bar with the [text].
  ///
  /// if [error] is `true`, the [text] is prefixed with `Error:`.
  ///
  /// If [onCancel] is set, an action that calls it when tapped is shown.
  void show(
    BuildContext context, {
    required String text,
    bool error = false,
    void Function(WidgetRef globalRef)? onCancel,
  }) {
    if (error) {
      text = '${context.l.error_snack_bar} $text';
    }

    final availableNotesTypes = NoteType.available;
    final behavior = availableNotesTypes.length == 1 ? SnackBarBehavior.floating : SnackBarBehavior.fixed;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: behavior,
        content: Text(text),
        action: onCancel != null
            ? SnackBarAction(label: context.fl.cancelButtonLabel, onPressed: () => onCancel(globalRef))
            : null,
      ),
    );
  }
}
