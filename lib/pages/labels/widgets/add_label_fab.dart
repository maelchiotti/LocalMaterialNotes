import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/labels/add.dart';

/// Floating action button to add a label.
class AddLabelFab extends ConsumerWidget {
  /// Default constructor.
  const AddLabelFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      tooltip: 'Add a label',
      onPressed: () => addLabel(context, ref),
      child: const Icon(Icons.add),
    );
  }
}
