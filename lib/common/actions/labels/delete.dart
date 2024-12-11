// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/actions/labels/select.dart';
import 'package:localmaterialnotes/common/actions/notes/select.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/dialogs/confirmation_dialog.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/labels/labels/labels_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers/notifiers.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';

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
