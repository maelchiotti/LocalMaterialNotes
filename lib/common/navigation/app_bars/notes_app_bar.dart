import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/common/widgets/note_tile.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/preferences/enums/layout.dart';
import 'package:localmaterialnotes/utils/preferences/enums/sort_method.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

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

  void _toggleLayout() {
    final newLayout = layoutNotifier.value == Layout.list ? Layout.grid : Layout.list;

    PreferencesUtils().set<String>(PreferenceKey.layout.name, newLayout.name);

    layoutNotifier.value = newLayout;
  }

  void _sort({SortMethod? method, bool? ascending}) {
    if (method != null) {
      final forceAscending = method == SortMethod.title;

      PreferencesUtils().set<String>(PreferenceKey.sortMethod.name, method.name);
      PreferencesUtils().set<bool>(PreferenceKey.sortAscending.name, forceAscending);

      setState(() {
        sortMethod = method;
        sortAscending = forceAscending;
      });
    } else if (ascending != null) {
      PreferencesUtils().set<bool>(PreferenceKey.sortAscending.name, ascending);

      setState(() {
        sortAscending = ascending;
      });
    }

    if (RouterRoute.currentRoute == RouterRoute.notes) {
      ref.read(notesProvider.notifier).sort();
    } else if (RouterRoute.currentRoute == RouterRoute.bin) {
      ref.read(binProvider.notifier).sort();
    }
  }

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
        IconButton(
          onPressed: _toggleLayout,
          tooltip: layoutNotifier.value == Layout.list
              ? localizations.tooltip_layout_grid
              : localizations.tooltip_layout_list,
          icon: Icon(layoutNotifier.value == Layout.list ? Icons.grid_view : Icons.view_list_outlined),
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
                      // Circumvent the normal PopupMenuButton behavior to use the second parameter or _sort
                      _sort(ascending: ascending);
                      context.pop();
                    },
                  ),
                ),
              ),
            ];
          },
          onSelected: (sort) => _sort(method: sort),
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
