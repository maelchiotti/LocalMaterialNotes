import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/separators.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/widgets/notes/note_tile.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// List of notes.
class NotesList extends ConsumerWidget {
  /// Default constructor.
  const NotesList({super.key});

  /// Returns the child of the widget.
  ///
  /// The child is either an empty placeholder if the [notes] are empty, are the [notes] list otherwise.
  Widget child(BuildContext context, List<Note> notes) {
    if (notes.isEmpty) {
      return context.location == NotesRoute().location ? EmptyPlaceholder.notes() : EmptyPlaceholder.bin();
    }

    // Use at least 2 columns for the grid view
    final columnsCount = MediaQuery.of(context).size.width ~/ Sizes.gridLayoutColumnWidth.size;
    final crossAxisCount = columnsCount > 2 ? columnsCount : 2;

    return ValueListenableBuilder(
      valueListenable: layoutNotifier,
      builder: (context, layout, child) {
        return ValueListenableBuilder(
          valueListenable: showTilesBackgroundNotifier,
          builder: (context, showTilesBackground, child) {
            return ValueListenableBuilder(
              valueListenable: showSeparatorsNotifier,
              builder: (context, showSeparators, child) {
                return layout == Layout.list
                    ? ListView.separated(
                        key: Keys.notesPageNotesListListLayout,
                        padding: showTilesBackground ? Paddings.notesWithBackground : Paddings.fab,
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          return NoteTile(
                            key: Keys.noteTile(index),
                            note: notes[index],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: showTilesBackground
                                ? Paddings.notesListWithBackgroundSeparation
                                : EdgeInsetsDirectional.zero,
                            child: showSeparators ? Separator.divider1indent8.horizontal : null,
                          );
                        },
                      )
                    : AlignedGridView.count(
                        key: Keys.notesPageNotesListGridLayout,
                        padding: Paddings.notesWithBackground,
                        mainAxisSpacing: Sizes.notesGridLayoutSpacing.size,
                        crossAxisSpacing: Sizes.notesGridLayoutSpacing.size,
                        crossAxisCount: crossAxisCount,
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          return NoteTile(
                            key: Keys.noteTile(index),
                            note: notes[index],
                          );
                        },
                      );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return context.location == NotesRoute().location
        ? ref.watch(notesProvider).when(
            data: (notes) {
              return child(context, notes);
            },
            error: (exception, stackTrace) {
              return ErrorPlaceholder(exception: exception, stackTrace: stackTrace);
            },
            loading: () {
              return const LoadingPlaceholder();
            },
          )
        : ref.watch(binProvider).when(
            data: (notes) {
              return child(context, notes);
            },
            error: (exception, stackTrace) {
              return ErrorPlaceholder(exception: exception, stackTrace: stackTrace);
            },
            loading: () {
              return const LoadingPlaceholder();
            },
          );
  }
}
