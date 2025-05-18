import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/label/label.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import 'select.dart';

/// Toggles whether the [labels] are pinned.
Future<void> togglePinLabels(WidgetRef ref, {required List<Label> labels}) async {
  await ref.read(labelsProvider.notifier).togglePin(labels);

  exitLabelsSelectionMode(ref);
}
