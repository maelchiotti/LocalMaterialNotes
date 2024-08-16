import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/preferences/enums/sort_method.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/common/widgets/notes/note_tile.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// Notes list and bin's app bar.
///
/// Contains:
///   - The title of the notes list route or the bin route.
///   - The button to toggle the notes layout.
///   - The button to change the notes sorting method.
///   - The button to search through the notes.
class NotesAppBar extends ConsumerStatefulWidget {
  const NotesAppBar({super.key});

  @override
  ConsumerState<NotesAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends ConsumerState<NotesAppBar> {
  final searchController = SearchController();

  final provider = RouterRoute.currentRoute == RouterRoute.notes ? notesProvider : binProvider;

  SortMethod sortMethod = SortMethod.fromPreference();
  bool sortAscending = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

  @override
  void initState() {
    super.initState();
  }

  /// Toggles the notes layout.
  void _toggleLayout() {
    final newLayout = layoutNotifier.value == Layout.list ? Layout.grid : Layout.list;

    PreferencesUtils().set<String>(PreferenceKey.layout.name, newLayout.name);

    layoutNotifier.value = newLayout;
  }

  /// Sorts the notes according to the [sortMethod] and whether they should be sorted in [ascending] order.
  void _sort({SortMethod? sortMethod, bool? ascending}) {
    // The 'Ascending' menu item was taped
    if (sortMethod == SortMethod.ascending) {
      final oldAscendingPreference = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

      PreferencesUtils().set<bool>(PreferenceKey.sortAscending.name, !oldAscendingPreference);

      setState(() {
        sortAscending = !oldAscendingPreference;
      });
    }

    // The 'Date' or 'Title' menu items were taped
    else if (sortMethod != null) {
      final forceAscending = sortMethod == SortMethod.title;

      PreferencesUtils().set<String>(PreferenceKey.sortMethod.name, sortMethod.name);
      PreferencesUtils().set<bool>(PreferenceKey.sortAscending.name, forceAscending);

      setState(() {
        this.sortMethod = sortMethod;
        sortAscending = forceAscending;
      });
    }

    // The checkbox of the 'Ascending' menu item was toggled
    else if (ascending != null) {
      PreferencesUtils().set<bool>(PreferenceKey.sortAscending.name, ascending);

      setState(() {
        sortAscending = ascending;
      });
    }

    RouterRoute.isBin ? ref.read(binProvider.notifier).sort() : ref.read(notesProvider.notifier).sort();
  }

  /// Filters the [notes] according to the [search].
  List<NoteTile> _filterNotes(String? search, List<Note> notes) {
    if (search == null || search.isEmpty) {
      return [];
    }

    return notes.where((note) {
      return note.matchesSearch(search);
    }).map((note) {
      return NoteTile.searchView(note);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final searchButtonPlaceholder = IconButton(
      onPressed: null,
      icon: const Icon(Icons.search),
      tooltip: localizations.tooltip_search,
    );

    return AppBar(
      leading: DrawerButton(
        onPressed: () => drawerKey.currentState!.openDrawer(),
      ),
      title: Text(RouterRoute.currentRoute.title),
      actions: [
        ValueListenableBuilder(
          valueListenable: layoutNotifier,
          builder: (context, layout, child) {
            final isListLayout = layout == Layout.list;

            return IconButton(
              onPressed: _toggleLayout,
              tooltip: isListLayout ? localizations.tooltip_layout_grid : localizations.tooltip_layout_list,
              icon: Icon(isListLayout ? Icons.grid_view : Icons.view_list_outlined),
            );
          },
        ),
        PopupMenuButton<SortMethod>(
          icon: const Icon(Icons.sort),
          tooltip: localizations.tooltip_sort,
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: SortMethod.date,
                child: ListTile(
                  selected: sortMethod == SortMethod.date,
                  leading: const Icon(Icons.calendar_month),
                  title: Text(localizations.sort_date),
                ),
              ),
              PopupMenuItem(
                value: SortMethod.title,
                child: ListTile(
                  selected: sortMethod == SortMethod.title,
                  leading: const Icon(Icons.sort_by_alpha),
                  title: Text(localizations.sort_title),
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: SortMethod.ascending,
                child: ListTile(
                  title: Text(localizations.sort_ascending),
                  trailing: Checkbox(
                    value: sortAscending,
                    onChanged: (ascending) {
                      _sort(ascending: ascending);

                      context.pop();
                    },
                  ),
                ),
              ),
            ];
          },
          onSelected: (sortMethod) => _sort(sortMethod: sortMethod),
        ),
        ref.watch(provider).when(
          data: (notes) {
            if (notes.isEmpty) {
              return searchButtonPlaceholder;
            }

            return SearchAnchor(
              viewHintText: localizations.tooltip_search,
              searchController: searchController,
              builder: (context, controller) {
                return IconButton(
                  onPressed: () => controller.openView(),
                  icon: const Icon(Icons.search),
                  tooltip: localizations.tooltip_search,
                );
              },
              suggestionsBuilder: (_, controller) => _filterNotes(controller.text, notes),
            );
          },
          error: (error, stackTrace) {
            return const EmptyPlaceholder();
          },
          loading: () {
            return searchButtonPlaceholder;
          },
        ),
        Padding(padding: Paddings.custom.appBarActionsEnd),
      ],
    );
  }
}
