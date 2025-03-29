import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../models/label/label.dart';
import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/preferences/preferences_provider.dart';
import '../../constants/paddings.dart';
import '../../constants/separators.dart';
import '../../constants/sizes.dart';
import '../../preferences/enums/layout.dart';
import '../../preferences/preference_key.dart';
import '../placeholders/empty_placeholder.dart';
import '../placeholders/error_placeholder.dart';
import '../placeholders/loading_placeholder.dart';
import 'note_tile.dart';

/// List of notes.
class NotesList extends ConsumerWidget {
  /// Default constructor.
  const NotesList({super.key, required this.notesStatus, this.label});

  /// The status of the notes in the page.
  final NoteStatus notesStatus;

  /// The current label filter.
  ///
  /// Used instead of [currentLabelFilter] to avoid a provider rebuild when it changes.
  final Label? label;

  /// Returns the child of the widget.
  ///
  /// The child is either an empty placeholder if the [notes] are empty, are the [notes] list otherwise.
  Widget child(BuildContext context, WidgetRef ref, List<Note> notes) {
    if (notes.isEmpty) {
      return switch (notesStatus) {
        NoteStatus.available => EmptyPlaceholder.available(context),
        NoteStatus.archived => EmptyPlaceholder.archived(context),
        NoteStatus.deleted => EmptyPlaceholder.deleted(context),
      };
    }

    final showTilesBackground = PreferenceKey.showTilesBackground.preferenceOrDefault;
    final showSeparators = PreferenceKey.showSeparators.preferenceOrDefault;

    final layout = ref.watch(preferencesProvider.select((preferences) => preferences.layout));

    // Use at least 2 columns for the grid view
    final columnsCount = MediaQuery.of(context).size.width ~/ Sizes.gridLayoutColumnWidth.size;
    final crossAxisCount = columnsCount > 2 ? columnsCount : 2;

    return layout == Layout.list
        ? ListView.separated(
          padding: showTilesBackground ? Paddings.notesWithBackground : Paddings.fab,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteTile(note: notes[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return Padding(
              padding: showTilesBackground ? Paddings.notesListWithBackgroundSeparation : EdgeInsetsDirectional.zero,
              child: showSeparators ? Separator.horizontal(indent: 8) : null,
            );
          },
        )
        : AlignedGridView.count(
          padding: Paddings.notesWithBackground,
          mainAxisSpacing: Sizes.notesGridLayoutSpacing.size,
          crossAxisSpacing: Sizes.notesGridLayoutSpacing.size,
          crossAxisCount: crossAxisCount,
          itemCount: notes.length,
          itemBuilder: (context, index) => NoteTile(note: notes[index]),
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(notesProvider(status: notesStatus, label: label))
        .when(
          data: (notes) => child(context, ref, notes),
          error: (exception, stackTrace) => ErrorPlaceholder(exception: exception, stackTrace: stackTrace),
          loading: () => const LoadingPlaceholder(),
        );
  }
}
