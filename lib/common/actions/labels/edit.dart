import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/label/label.dart';
import '../../../pages/labels/dialogs/label_dialog.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../../constants/constants.dart';

/// Opens the dialog to edit the [label].
Future<void> editLabel(BuildContext context, WidgetRef ref, {required Label label}) async {
  final editedLabel = await showAdaptiveDialog<Label>(
    context: context,
    useRootNavigator: false,
    builder: (context) => LabelDialog(
      title: l.dialog_label_edit,
      label: label,
    ),
  );

  if (editedLabel == null) {
    return;
  }

  await ref.read(labelsProvider.notifier).edit(editedLabel);
}
