import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/label/label.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../extensions/build_context_extension.dart';
import '../authentication.dart';
import 'select.dart';

/// Deletes the [label].
///
/// Returns `true` if the [label] was deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> deleteLabel(BuildContext context, WidgetRef ref, {required Label label}) async {
  if (!await askForConfirmation(
    context,
    context.l.dialog_delete_label,
    context.l.dialog_delete_label_body(1),
    context.l.dialog_delete_label,
    irreversible: true,
  )) {
    return false;
  }

  if (!context.mounted) {
    return false;
  }

  // If required, ask for authentication
  if (label.requiresAuthentication) {
    final authenticated = await authenticate(context, reason: context.l.lock_page_reason_action);

    if (!authenticated) {
      return false;
    }
  }

  return await ref.read(labelsProvider.notifier).delete([label]);
}

/// Deletes the [labels].
///
/// Returns `true` if the [labels] were deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> deleteLabels(BuildContext context, WidgetRef ref, {required List<Label> labels}) async {
  if (!await askForConfirmation(
    context,
    context.l.dialog_delete_label,
    context.l.dialog_delete_label_body(labels.length),
    context.l.dialog_delete_label,
    irreversible: true,
  )) {
    return false;
  }

  if (!context.mounted) {
    return false;
  }

  // If required, ask for authentication
  final requiresAuthentication = labels.any((label) => label.requiresAuthentication);
  if (requiresAuthentication) {
    final authenticated = await authenticate(context, reason: context.l.lock_page_reason_action);

    if (!authenticated) {
      return false;
    }
  }

  final succeeded = await ref.read(labelsProvider.notifier).delete(labels);

  if (context.mounted) {
    exitLabelsSelectionMode(ref);
  }

  return succeeded;
}
