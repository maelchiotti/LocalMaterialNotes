import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/note_tile.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

class BinPage extends ConsumerStatefulWidget {
  const BinPage();

  @override
  ConsumerState<BinPage> createState() => _BinPageState();
}

class _BinPageState extends ConsumerState<BinPage> {
  Future<void> _refresh() async {
    await ref.read(binProvider.notifier).get();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ScrollConfiguration(
        behavior: scrollBehavior,
        child: ref.watch(binProvider).when(
          data: (notes) {
            if (notes.isEmpty) {
              return EmptyPlaceholder.bin();
            }

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NoteTile(notes[index]);
              },
            );
          },
          error: (error, stackTrace) {
            return const ErrorPlaceholder();
          },
          loading: () {
            return const LoadingPlaceholder();
          },
        ),
      ),
    );
  }
}
