import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/delete.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

class FabEmptyBin extends ConsumerWidget {
  const FabEmptyBin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deletedNotesCount = ref.watch(binProvider).value?.length ?? 0;

    return FloatingActionButton(
      tooltip: localizations.tooltip_fab_empty_bin,
      onPressed: deletedNotesCount > 0 ? () => emptyBin(ref) : null,
      child: const Icon(Icons.delete_forever),
    );
  }
}
