import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/label/label.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import 'select.dart';

/// Toggles whether the [labels] are visible.
Future<void> toggleVisibleLabels(WidgetRef ref, {required List<Label> labels}) async {
  await ref.read(labelsProvider.notifier).toggleVisible(labels);

  exitLabelsSelectionMode(ref);
}
