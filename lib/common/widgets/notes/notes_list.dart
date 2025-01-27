import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../models/label/label.dart';
import '../../../models/note/note.dart';
import '../../../providers/bin/bin_provider.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../../providers/preferences/preferences_provider.dart';
import '../../constants/paddings.dart';
import '../../constants/separators.dart';
import '../../constants/sizes.dart';
import '../../preferences/enums/layout.dart';
import '../keys.dart';
import '../placeholders/empty_placeholder.dart';
import '../placeholders/error_placeholder.dart';
import '../placeholders/loading_placeholder.dart';
import 'note_tile.dart';

/// List of notes.
class NotesList extends ConsumerWidget {
  /// Default constructor.
  const NotesList({
    super.key,
    this.label,
    this.notesPage = true,
  });

  /// The current label filter.
  ///
  /// Used instead of [currentLabelFilter] to avoid a provider rebuild when it changes.
  final Label? label;

  /// Whether the current page is the notes list.
  final bool notesPage;

  /// Returns the child of the widget.
  ///
  /// The child is either an empty placeholder if the [notes] are empty, are the [notes] list otherwise.
  Widget child(BuildContext context, WidgetRef ref, List<Note> notes) {
    if (notes.isEmpty) {
      return notesPage ? EmptyPlaceholder.notes() : EmptyPlaceholder.bin();
    }

    final layout = ref.watch(preferencesProvider.select((preferences) => preferences.layout));
    final showTilesBackground = ref.watch(preferencesProvider.select((preferences) => preferences.showTilesBackground));
    final showSeparators = ref.watch(preferencesProvider.select((preferences) => preferences.showSeparators));

    // Use at least 2 columns for the grid view
    final columnsCount = MediaQuery.of(context).size.width ~/ Sizes.gridLayoutColumnWidth.size;
    final crossAxisCount = columnsCount > 2 ? columnsCount : 2;

    return layout == Layout.list
        ? ListView.separated(
            key: Keys.notesPageNotesListListLayout,
            padding: showTilesBackground ? Paddings.notesWithBackground : Paddings.fab,
            itemCount: notes.length,
            itemBuilder: (context, index) => NoteTile(
              key: Keys.noteTile(index),
              note: notes[index],
            ),
            separatorBuilder: (BuildContext context, int index) => Padding(
              padding: showTilesBackground ? Paddings.notesListWithBackgroundSeparation : EdgeInsetsDirectional.zero,
              child: showSeparators ? Separator.divider1indent8.horizontal : null,
            ),
          )
        : AlignedGridView.count(
            key: Keys.notesPageNotesListGridLayout,
            padding: Paddings.notesWithBackground,
            mainAxisSpacing: Sizes.notesGridLayoutSpacing.size,
            crossAxisSpacing: Sizes.notesGridLayoutSpacing.size,
            crossAxisCount: crossAxisCount,
            itemCount: notes.length,
            itemBuilder: (context, index) => NoteTile(
              key: Keys.noteTile(index),
              note: notes[index],
            ),
          );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return notesPage
        ? ref.watch(notesProvider(label: label)).when(
              data: (notes) {
                return child(context, ref, notes);
              },
              error: (exception, stackTrace) => ErrorPlaceholder(exception: exception, stackTrace: stackTrace),
              loading: () => const LoadingPlaceholder(),
            )
        : ref.watch(binProvider).when(
              data: (notes) => child(context, ref, notes),
              error: (exception, stackTrace) => ErrorPlaceholder(exception: exception, stackTrace: stackTrace),
              loading: () => const LoadingPlaceholder(),
            );
  }
}
