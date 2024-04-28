import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:localmaterialnotes/common/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/note_tile.dart';
import 'package:localmaterialnotes/providers/layout/layout_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/separators.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';
import 'package:localmaterialnotes/utils/preferences/layout.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage();

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(notesProvider).when(
      data: (notes) {
        if (notes.isEmpty) {
          return EmptyPlaceholder.notes();
        }

        final useSeparators =
            PreferencesManager().get<bool>(PreferenceKey.separator) ?? PreferenceKey.separator.defaultValue! as bool;
        final layout = ref.watch(layoutStateProvider) ?? Layout.fromPreferences();

        // Use at least 2 columns for the grid view
        final columnsCount = MediaQuery.of(context).size.width ~/ Sizes.custom.gridLayoutColumnWidth;
        final crossAxisCount = columnsCount > 2 ? columnsCount : 2;

        // Wrap with Material to fix the tile background color not updating in real time
        // when the tile is selected and the view is scrolled
        // see: https://github.com/flutter/flutter/issues/86584
        return Material(
          child: layout == Layout.list
              ? useSeparators
                  ? ListView.separated(
                      padding: Paddings.custom.fab,
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return NoteTile(notes[index]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Separator.divider1indent8.horizontal;
                      },
                    )
                  : ListView.builder(
                      padding: Paddings.custom.fab,
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        return NoteTile(notes[index]);
                      },
                    )
              : AlignedGridView.count(
                  crossAxisCount: crossAxisCount,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return NoteTile(notes[index]);
                  },
                ),
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
