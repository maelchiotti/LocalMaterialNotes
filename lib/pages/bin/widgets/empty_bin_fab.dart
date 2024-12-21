import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/actions/notes/delete.dart';
import '../../../common/constants/constants.dart';
import '../../../providers/bin/bin_provider.dart';

/// Floating action button to empty the bin.
class EmptyBinFab extends ConsumerWidget {
  /// Default constructor.
  const EmptyBinFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletedNotesCount = ref.watch(binProvider).value?.length;

    return deletedNotesCount != null && deletedNotesCount != 0
        ? FloatingActionButton(
            tooltip: l.tooltip_fab_empty_bin,
            onPressed: () => emptyBin(context, ref),
            child: const Icon(Icons.delete_forever),
          )
        : SizedBox.shrink();
  }
}
