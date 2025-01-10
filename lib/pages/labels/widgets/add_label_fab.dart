import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/actions/labels/add.dart';
import '../../../common/constants/constants.dart';

/// FAB to add a label.
class AddLabelFab extends ConsumerWidget {
  /// Floating action button to add a new label.
  const AddLabelFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      tooltip: l.tooltip_fab_add_label,
      onPressed: () => addLabel(context, ref),
      child: const Icon(Icons.add),
    );
  }
}
