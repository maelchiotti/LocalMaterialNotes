import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/constants.dart';
import '../../constants/paddings.dart';
import '../../preferences/enums/layout.dart';
import '../../preferences/enums/sort_method.dart';
import '../../preferences/preference_key.dart';
import '../../widgets/notes/note_tile.dart';
import '../../widgets/placeholders/empty_placeholder.dart';
import '../../../models/label/label.dart';
import '../../../models/note/note.dart';
import '../../../providers/bin/bin_provider.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/preferences/preferences_provider.dart';
import '../../../services/notes/notes_service.dart';
import '../../../utils/keys.dart';

import '../../preferences/watched_preferences.dart';

/// Notes list and bin's app bar.
///
/// Contains:
///   - The title of the notes list route or the bin route.
///   - The button to toggle the notes layout.
///   - The button to change the notes sorting method.
///   - The button to search through the notes.
class NotesAppBar extends ConsumerWidget {
  /// Default constructor.
  const NotesAppBar({
    super.key,
    required this.title,
    this.label,
    this.notesPage = true,
  });

  /// Title to display in the app bar.
  final String title;

  /// Whether the current page is the notes list.
  final bool notesPage;

  /// The label on which the notes are filtered if in a label page.
  final Label? label;

  /// Returns the placeholder for the search button used when the search isn't available.
  Widget get searchButtonPlaceholder => IconButton(
        onPressed: null,
        icon: const Icon(Icons.search),
        tooltip: l.tooltip_search,
      );

  /// Toggles the notes layout.
  void toggleLayout(WidgetRef ref, Layout currentLayout) {
    final newLayout = currentLayout == Layout.list ? Layout.grid : Layout.list;

    PreferenceKey.layout.set(newLayout.name);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(layout: newLayout));
  }

  /// Sorts the notes according to the [sortMethod] and whether they should be sorted in [ascending] order.
  void sort(BuildContext context, WidgetRef ref, {SortMethod? sortMethod, bool? ascending}) {
    // The 'Ascending' menu item was taped
    if (sortMethod == SortMethod.ascending) {
      final oldAscendingPreference = PreferenceKey.sortAscending.getPreferenceOrDefault();

      PreferenceKey.sortAscending.set(!oldAscendingPreference);
    }

    // The 'Creation date', 'Edited date' or 'Title' menu items were taped
    else if (sortMethod != null) {
      final oldSortMethod = SortMethod.fromPreference();

      PreferenceKey.sortMethod.set(sortMethod.name);

      // Force the ascending sort when sorting by title
      if (sortMethod == SortMethod.title) {
        PreferenceKey.sortAscending.set(true);
      }
      // Force the descending sort when sorting by a date and if the previous sort was not based on a date
      else if (!oldSortMethod.onDate && sortMethod.onDate) {
        PreferenceKey.sortAscending.set(false);
      }
    }

    // The checkbox of the 'Ascending' menu item was toggled
    else if (ascending != null) {
      PreferenceKey.sortAscending.set(ascending);

      Navigator.pop(context);
    }

    notesPage ? ref.read(notesProvider.notifier).sort() : ref.read(binProvider.notifier).sort();
  }

  /// Searches for the notes that match the [search].
  Future<List<NoteTile>> searchNotes(String? search) async {
    if (search == null || search.isEmpty) {
      return [];
    }

    final notes = await NotesService().search(search, notesPage, label?.name);

    return notes
        .mapIndexed((index, note) => NoteTile.searchView(
              key: Keys.noteTile(index),
              note: note,
            ))
        .toList();
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
      builder: (context, controller) => IconButton(
        key: Keys.appBarSearchIconButton,
        onPressed: () => controller.openView(),
        icon: const Icon(Icons.search),
        tooltip: l.tooltip_search,
      ),
      suggestionsBuilder: (context, controller) => searchNotes(controller.text),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortMethod = SortMethod.fromPreference();
    final sortAscending = PreferenceKey.sortAscending.getPreferenceOrDefault();
    final layout = ref.watch(preferencesProvider.select((preferences) => preferences.layout));

    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          key: Keys.appBarLayoutIconButton,
          onPressed: () => toggleLayout(ref, layout),
          tooltip: layout == Layout.list ? l.tooltip_layout_grid : l.tooltip_layout_list,
          icon: Icon(layout == Layout.list ? Icons.grid_view : Icons.view_list),
        ),
        PopupMenuButton<SortMethod>(
          key: Keys.appBarSortIconButton,
          icon: const Icon(Icons.sort),
          tooltip: l.tooltip_sort,
          itemBuilder: (context) => [
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
                  onChanged: (ascending) => sort(context, ref, ascending: ascending),
                ),
              ),
            ),
          ],
          onSelected: (sortMethod) => sort(context, ref, sortMethod: sortMethod),
        ),
        if (notesPage)
          ref.watch(notesProvider).when(
                data: (notes) => child(context, notes),
                error: (error, stackTrace) => const EmptyPlaceholder(),
                loading: () => searchButtonPlaceholder,
              )
        else
          ref.watch(notesProvider).when(
                data: (notes) => child(context, notes),
                error: (error, stackTrace) => const EmptyPlaceholder(),
                loading: () => searchButtonPlaceholder,
              ),
        Padding(padding: Paddings.appBarActionsEnd),
      ],
    );
  }
}
