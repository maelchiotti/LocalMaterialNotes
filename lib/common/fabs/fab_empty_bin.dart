import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/delete.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';

/// Floating action button to empty the bin.
class FabEmptyBin extends ConsumerWidget {
  const FabEmptyBin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletedNotesCount = ref.watch(binProvider).value?.length;

    return deletedNotesCount != null && deletedNotesCount != 0
        ? FloatingActionButton(
            tooltip: localizations.tooltip_fab_empty_bin,
            onPressed: () => emptyBin(ref),
            child: const Icon(Icons.delete_forever),
          )
        : Container();
  }
}
