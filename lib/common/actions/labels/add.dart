import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/label/label.dart';
import '../../../pages/labels/dialogs/label_dialog.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../../extensions/build_context_extension.dart';

/// Adds a label.
Future<void> addLabel(BuildContext context, WidgetRef ref) async {
  final label = await showAdaptiveDialog<Label>(
    context: context,
    useRootNavigator: false,
    builder: (context) => LabelDialog(title: context.l.dialog_label_add),
  );

  if (label == null) {
    return;
  }

  await ref.read(labelsProvider.notifier).edit(label);
}
