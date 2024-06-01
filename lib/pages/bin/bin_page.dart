import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:localmaterialnotes/common/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/note_tile.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/layout/layout_provider.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/separators.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';
import 'package:localmaterialnotes/utils/preferences/layout.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

class BinPage extends ConsumerStatefulWidget {
  const BinPage();

  @override
  ConsumerState<BinPage> createState() => _BinPageState();
}

class _BinPageState extends ConsumerState<BinPage> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(binProvider).when(
      data: (notes) {
        if (notes.isEmpty) {
          return EmptyPlaceholder.bin();
        }

        final layout = ref.watch(layoutStateProvider) ?? Layout.fromPreference();
        final useSeparators = PreferenceKey.showSeparators.getPreferenceOrDefault<bool>();
        final showTilesBackground = PreferenceKey.showTilesBackground.getPreferenceOrDefault<bool>();

        // Use at least 2 columns for the grid view
        final columnsCount = MediaQuery.of(context).size.width ~/ Sizes.custom.gridLayoutColumnWidth;
        final crossAxisCount = columnsCount > 2 ? columnsCount : 2;

        return layout == Layout.list
            ? ListView.separated(
                padding: showTilesBackground ? Paddings.custom.notesWithBackground : Paddings.custom.fab,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return NoteTile(notes[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: showTilesBackground
                        ? Paddings.custom.notesListViewWithBackgroundSeparation
                        : EdgeInsetsDirectional.zero,
                    child: useSeparators ? Separator.divider1indent8.horizontal : null,
                  );
                },
              )
            : AlignedGridView.count(
                padding: Paddings.custom.notesWithBackground,
                mainAxisSpacing: Sizes.custom.notesGridViewSpacing,
                crossAxisSpacing: Sizes.custom.notesGridViewSpacing,
                crossAxisCount: crossAxisCount,
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
    );
  }
}
