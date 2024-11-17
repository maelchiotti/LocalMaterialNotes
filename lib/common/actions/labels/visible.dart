import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/labels/select.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/providers/labels/labels/labels_provider.dart';

/// Toggles the visible status of the [label].
///
/// Returns `true` if the visible status of the [label] was toggled, `false` otherwise.
Future<bool> toggleVisibleLabel(WidgetRef ref, Label? label) async {
  if (label == null) {
    return false;
  }

  await ref.read(labelsProvider.notifier).toggleVisible(label);

  return false;
}

/// Toggles the visible status of the [labels].
Future<void> toggleVisibleLabels(WidgetRef ref, List<Label> labels) async {
  await ref.read(labelsProvider.notifier).toggleVisibleAll(labels);

  exitLabelsSelectionMode(ref);
}
