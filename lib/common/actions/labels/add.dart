import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/pages/labels/dialogs/label_dialog.dart';
import 'package:localmaterialnotes/providers/labels/labels/labels_provider.dart';

/// Adds a label.
Future<void> addLabel(BuildContext context, WidgetRef ref) async {
  final label = await showAdaptiveDialog<Label>(
    context: context,
    builder: (context) {
      return LabelDialog(title: 'Add label');
    },
  );

  if (label == null) {
    return;
  }

  ref.read(labelsProvider.notifier).edit(label);
}
