import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/common/widgets/note_tile.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';

class SearchSortAppBar extends ConsumerStatefulWidget {
  const SearchSortAppBar({super.key});

  @override
  ConsumerState<SearchSortAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends ConsumerState<SearchSortAppBar> {
  final provider = RouterRoute.currentRoute == RouterRoute.notes ? notesProvider : binProvider;

  SortMethod sortMethod = SortMethod.methodFromPreferences();
  bool sortAscending = SortMethod.ascendingFromPreferences;

  List<NoteTile> _filterNotes(String? search, List<Note> notes) {
    if (search == null || search.isEmpty) return [];

    return notes.where((note) {
      return note.containsText(search);
    }).map((note) {
      return NoteTile.searchView(note);
    }).toList();
  }

  void _sort(SortMethod sort) {
    if (sort == SortMethod.ascending) {
      PreferencesManager().set<bool>(PreferenceKey.sortAscending.name, !sortAscending);
      setState(() {
        sortAscending = !sortAscending;
      });
    } else {
      PreferencesManager().set<String>(PreferenceKey.sortMethod.name, sort.name);
      setState(() {
        sortMethod = sort;
      });
    }

    if (RouterRoute.currentRoute == RouterRoute.notes) {
      ref.read(notesProvider.notifier).sort();
    } else if (RouterRoute.currentRoute == RouterRoute.bin) {
      ref.read(binProvider.notifier).sort();
    }
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
                    onChanged: (_) {
                      _sort(SortMethod.ascending);
                      context.pop();
                    },
                  ),
                ),
              ),
            ];
          },
          onSelected: (sort) => _sort(sort),
        ),
        ref.watch(provider).when(
          data: (notes) {
            if (notes.isEmpty) return searchButtonPlaceholder;

            return SearchAnchor(
              viewHintText: localizations.tooltip_search,
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
