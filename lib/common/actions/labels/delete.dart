import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'select.dart';
import '../../constants/constants.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../../models/label/label.dart';
import '../../../providers/labels/labels/labels_provider.dart';

/// Deletes the [label].
///
/// Returns `true` if the [label] was deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> deleteLabel(BuildContext context, WidgetRef ref, Label? label) async {
  if (label == null) {
    return false;
  }

  if (!await askForConfirmation(
    context,
    l.dialog_delete_label,
    l.dialog_delete_label_body(1),
    l.dialog_delete_label,
    irreversible: true,
  )) {
    return false;
  }

  return await ref.read(labelsProvider.notifier).delete(label);
}

/// Deletes the [labels].
///
/// Returns `true` if the [labels] were deleted, `false` otherwise.
///
/// First, asks for a confirmation if needed.
Future<bool> deleteLabels(BuildContext context, WidgetRef ref, List<Label> labels) async {
  if (!await askForConfirmation(
    context,
    l.dialog_delete_label,
    l.dialog_delete_label_body(labels.length),
    l.dialog_delete_label,
    irreversible: true,
  )) {
    return false;
  }

  final succeeded = await ref.read(labelsProvider.notifier).deleteAll(labels);

  if (context.mounted) {
    exitLabelsSelectionMode(ref);
  }

  return succeeded;
}
