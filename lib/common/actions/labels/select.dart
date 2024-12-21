import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/label/label.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Toggles the select status of the [label].
void toggleSelectLabel(WidgetRef ref, Label label) {
  label.selected ? ref.read(labelsProvider.notifier).unselect(label) : ref.read(labelsProvider.notifier).select(label);
}

/// Selects all the labels.
void selectAllLabels(WidgetRef ref) {
  ref.read(labelsProvider.notifier).selectAll();
}

/// Unselects all the labels.
void unselectAllLabels(WidgetRef ref) {
  ref.read(labelsProvider.notifier).unselectAll();
}

/// Exits the labels selection mode.
///
/// First unselects all the labels.
void exitLabelsSelectionMode(WidgetRef ref) {
  unselectAllLabels(ref);

  isLabelsSelectionModeNotifier.value = false;
}
