import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/label/label.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import 'select.dart';

/// Toggles the pined status of the [label].
///
/// Returns `true` if the pined status of the [label] was toggled, `false` otherwise.
Future<bool> togglePinLabel(BuildContext context, WidgetRef ref, {required Label label}) async {
  await ref.read(labelsProvider.notifier).togglePin(label);

  return false;
}

/// Toggles the pined status of the [labels].
Future<void> togglePinLabels(WidgetRef ref, {required List<Label> labels}) async {
  await ref.read(labelsProvider.notifier).togglePinAll(labels);

  exitLabelsSelectionMode(ref);
}
