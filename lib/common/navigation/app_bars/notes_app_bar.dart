import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/preferences/enums/sort_method.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/widgets/notes/note_tile.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Notes list and bin's app bar.
///
/// Contains:
///   - The title of the notes list route or the bin route.
///   - The button to toggle the notes layout.
///   - The button to change the notes sorting method.
///   - The button to search through the notes.
class NotesAppBar extends ConsumerWidget {
  /// Default constructor.
  const NotesAppBar({super.key});

  /// Returns the placeholder for the search button used when the search isn't available.
  Widget get searchButtonPlaceholder {
    return IconButton(
      onPressed: null,
      icon: const Icon(Icons.search),
      tooltip: l.tooltip_search,
    );
  }

  /// Returns the child of the widget.
  ///
  /// The child is either the [searchButtonPlaceholder] if the [notes] are empty, or the search anchor with the [notes]
  /// to search otherwise.
  Widget child(BuildContext context, List<Note> notes) {
    if (notes.isEmpty) {
      return searchButtonPlaceholder;
    }

    return SearchAnchor(
      key: Keys.searchViewSearchAnchor,
      viewHintText: l.tooltip_search,
      searchController: SearchController(),
      viewBackgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context, controller) {
        return IconButton(
          key: Keys.appBarSearchIconButton,
          onPressed: () => controller.openView(),
          icon: const Icon(Icons.search),
          tooltip: l.tooltip_search,
        );
      },
      suggestionsBuilder: (_, controller) => _filterNotes(controller.text, notes),
    );
  }

  /// Toggles the notes layout.
  void _toggleLayout() {
    final newLayout = layoutNotifier.value == Layout.list ? Layout.grid : Layout.list;

    PreferenceKey.layout.set<String>(newLayout.name);

    layoutNotifier.value = newLayout;
  }

  /// Sorts the notes according to the [sortMethod] and whether they should be sorted in [ascending] order.
  void _sort(BuildContext context, WidgetRef ref, {SortMethod? sortMethod, bool? ascending}) {
    // The 'Ascending' menu item was taped
    if (sortMethod == SortMethod.ascending) {
      final oldAscendingPreference = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

      PreferenceKey.sortAscending.set<bool>(!oldAscendingPreference);
    }

    // The 'Date' or 'Title' menu items were taped
    else if (sortMethod != null) {
      final forceAscending = sortMethod == SortMethod.title;

      PreferenceKey.sortMethod.set<String>(sortMethod.name);
      PreferenceKey.sortAscending.set<bool>(forceAscending);
    }

    // The checkbox of the 'Ascending' menu item was toggled
    else if (ascending != null) {
      PreferenceKey.sortAscending.set<bool>(ascending);

      Navigator.pop(context);
    }

    context.location == NotesRoute().location
        ? ref.read(notesProvider.notifier).sort()
        : ref.read(binProvider.notifier).sort();
  }

  /// Filters the [notes] according to the [search].
  List<NoteTile> _filterNotes(String? search, List<Note> notes) {
    if (search == null || search.isEmpty) {
      return [];
    }

    return notes.where((note) {
      return note.matchesSearch(search);
    }).mapIndexed((index, note) {
      return NoteTile.searchView(
        key: Keys.noteTile(index),
        note: note,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortMethod = SortMethod.fromPreference();
    final sortAscending = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

    return AppBar(
      title: Text(context.title(context)),
      actions: [
        ValueListenableBuilder(
          valueListenable: layoutNotifier,
          builder: (context, layout, child) {
            final isListLayout = layout == Layout.list;

            return IconButton(
              key: Keys.appBarLayoutIconButton,
              onPressed: _toggleLayout,
              tooltip: isListLayout ? l.tooltip_layout_grid : l.tooltip_layout_list,
              icon: Icon(isListLayout ? Icons.grid_view : Icons.view_list),
            );
          },
        ),
        PopupMenuButton<SortMethod>(
          key: Keys.appBarSortIconButton,
          icon: const Icon(Icons.sort),
          tooltip: l.tooltip_sort,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                key: Keys.sortCreatedDateMenuItem,
                value: SortMethod.createdDate,
                child: ListTile(
                  selected: sortMethod == SortMethod.createdDate,
                  leading: const Icon(Icons.calendar_month),
                  title: Text(l.button_sort_creation_date),
                ),
              ),
              PopupMenuItem(
                key: Keys.sortEditedDateMenuItem,
                value: SortMethod.editedDate,
                child: ListTile(
                  selected: sortMethod == SortMethod.editedDate,
                  leading: const Icon(Icons.edit_calendar),
                  title: Text(l.button_sort_edition_date),
                ),
              ),
              PopupMenuItem(
                key: Keys.sortTitleMenuItem,
                value: SortMethod.title,
                child: ListTile(
                  selected: sortMethod == SortMethod.title,
                  leading: const Icon(Icons.sort_by_alpha),
                  title: Text(l.button_sort_title),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                key: Keys.sortAscendingMenuItem,
                value: SortMethod.ascending,
                child: ListTile(
                  title: Text(l.button_sort_ascending),
                  trailing: Checkbox(
                    value: sortAscending,
                    onChanged: (ascending) => _sort(context, ref, ascending: ascending),
                  ),
                ),
              ),
            ];
          },
          onSelected: (sortMethod) => _sort(context, ref, sortMethod: sortMethod),
        ),
        if (context.location == NotesRoute().location)
          ref.watch(notesProvider).when(
            data: (notes) {
              return child(context, notes);
            },
            error: (error, stackTrace) {
              return const EmptyPlaceholder();
            },
            loading: () {
              return searchButtonPlaceholder;
            },
          )
        else
          ref.watch(binProvider).when(
            data: (notes) {
              return child(context, notes);
            },
            error: (error, stackTrace) {
              return const EmptyPlaceholder();
            },
            loading: () {
              return searchButtonPlaceholder;
            },
          ),
        Padding(padding: Paddings.appBarActionsEnd),
      ],
    );
  }
}
