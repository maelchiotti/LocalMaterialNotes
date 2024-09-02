import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/preferences/enums/sort_method.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/common/widgets/notes/note_tile.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/routing/routes/routing_route.dart';

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

  SortMethod sortMethod = SortMethod.fromPreference();
  bool sortAscending = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

  Widget get searchButtonPlaceholder {
    return IconButton(
      onPressed: null,
      icon: const Icon(Icons.search),
      tooltip: localizations.tooltip_search,
    );
  }

  Widget child(List<Note> notes) {
    if (notes.isEmpty) {
      return searchButtonPlaceholder;
    }

    return SearchAnchor(
      viewHintText: localizations.tooltip_search,
      searchController: searchController,
      viewBackgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context, controller) {
        return IconButton(
          onPressed: () => controller.openView(),
          icon: const Icon(Icons.search),
          tooltip: localizations.tooltip_search,
        );
      },
      suggestionsBuilder: (_, controller) => _filterNotes(controller.text, notes),
    );
  }

  /// Toggles the notes layout.
  void _toggleLayout() {
    final newLayout = layoutNotifier.value == Layout.list ? Layout.grid : Layout.list;

    PreferencesUtils().set<String>(PreferenceKey.layout, newLayout.name);

    layoutNotifier.value = newLayout;
  }

  /// Sorts the notes according to the [sortMethod] and whether they should be sorted in [ascending] order.
  void _sort({SortMethod? sortMethod, bool? ascending}) {
    // The 'Ascending' menu item was taped
    if (sortMethod == SortMethod.ascending) {
      final oldAscendingPreference = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

      PreferencesUtils().set<bool>(PreferenceKey.sortAscending, !oldAscendingPreference);

      setState(() {
        sortAscending = !oldAscendingPreference;
      });
    }

    // The 'Date' or 'Title' menu items were taped
    else if (sortMethod != null) {
      final forceAscending = sortMethod == SortMethod.title;

      PreferencesUtils().set<String>(PreferenceKey.sortMethod, sortMethod.name);
      PreferencesUtils().set<bool>(PreferenceKey.sortAscending, forceAscending);

      setState(() {
        this.sortMethod = sortMethod;
        sortAscending = forceAscending;
      });
    }

    // The checkbox of the 'Ascending' menu item was toggled
    else if (ascending != null) {
      PreferencesUtils().set<bool>(PreferenceKey.sortAscending, ascending);

      setState(() {
        sortAscending = ascending;
      });
    }

    context.route == RoutingRoute.notes
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
    }).map((note) {
      return NoteTile.searchView(note);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: DrawerButton(
        onPressed: () => scaffoldDrawerKey.currentState!.openDrawer(),
      ),
      title: Text(RoutingRoute.title(context)),
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
        if (context.route == RoutingRoute.notes)
          ref.watch(notesProvider).when(
            data: (notes) {
              return child(notes);
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
              return child(notes);
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
