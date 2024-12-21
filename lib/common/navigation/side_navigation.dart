import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/constants.dart';
import '../constants/paddings.dart';
import '../constants/sizes.dart';
import '../preferences/preference_key.dart';
import '../widgets/placeholders/error_placeholder.dart';
import '../../models/label/label.dart';
import '../../navigation/navigation_routes.dart';
import '../../navigation/navigator_utils.dart';
import '../../pages/bin/bin_page.dart';
import '../../pages/labels/labels_page.dart';
import '../../pages/notes/notes_page.dart';
import '../../pages/settings/settings_main_page.dart';
import '../../providers/labels/labels_navigation/labels_navigation_provider.dart';
import '../../providers/notifiers/notifiers.dart';
import '../../utils/asset.dart';
import '../../utils/keys.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

/// Side navigation with the drawer.
class SideNavigation extends ConsumerStatefulWidget {
  /// Default constructor.
  const SideNavigation({super.key});

  @override
  ConsumerState<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends ConsumerState<SideNavigation> {
  /// Index of the currently selected drawer destination.
  late int _index;

  /// Returns whether the [route] is the home page.
  bool isHomeRoute(String route) {
    return route == '/' || route == NavigationRoute.notes.name;
  }

  /// Returns whether the [route] is the home page.
  bool isLabelRoute(String route) {
    return route.startsWith('label-');
  }

  /// Sets the index of the navigation drawer.
  void setIndex([List<Label>? labels]) {
    // Get the name of the current route
    final route = ModalRoute.of(context)?.settings.name;
    assert(route != null, 'Missing current route while navigating');
    route!;

    final int index;

    // The labels are enabled
    if (labels != null) {
      if (isHomeRoute(route)) {
        index = 0;
      } else if (isLabelRoute(route)) {
        final labelName = route.substring(6);
        final label = labels.firstWhere(
          (label) => label.name == labelName,
          orElse: () {
            throw Exception('Unknown label name while setting the index of the navigation drawer: $labelName');
          },
        );

        index = labels.indexOf(label) + 1;
      } else if (route == NavigationRoute.manageLabels.name) {
        index = labels.length + 1;
      } else if (route == NavigationRoute.bin.name) {
        index = labels.length + 2;
      } else if (route == NavigationRoute.settings.name) {
        index = labels.length + 3;
      } else {
        throw Exception('Unknown route while setting the index of the navigation drawer: $route');
      }
    }

    // The labels are disabled
    else {
      if (route == '/' || route == NavigationRoute.notes.name) {
        index = 0;
      } else if (route == NavigationRoute.bin.name) {
        index = 1;
      } else if (route == NavigationRoute.settings.name) {
        index = 2;
      } else {
        throw Exception('Unknown route while setting the index of the navigation drawer: $route');
      }
    }

    _index = index;
  }

  /// Navigates to the route corresponding to the [index].
  void navigate(int index, List<Label>? labels) {
    // If the new route is the same as the current one, just close the drawer
    if (_index == index) {
      Navigator.pop(context);

      return;
    }

    // Get the name of the current route
    final route = ModalRoute.of(context)?.settings.name;
    assert(route != null, 'Missing current route while navigating');
    route!;

    // Close the navigation drawer
    Navigator.pop(context);

    // The labels are enabled
    if (labels != null) {
      final isNewRouteLabelRoute = index > 0 && index <= labels.length;

      // Clear the current note if the new route is not the notes list or the labels list
      if (index != 0 && !isNewRouteLabelRoute) {
        currentNoteNotifier.value = null;
      }

      if (index == 0) {
        // If in a label route, go to the notes page
        if (isLabelRoute(route)) {
          NavigationRoute.notes.go(context, NotesPage());
        }
        // If not in a label route, pop to the notes page
        else {
          Navigator.pop(context);
        }
      } else if (isNewRouteLabelRoute) {
        final label = labels[index - 1];

        NavigatorUtils.go(
          context,
          '${NavigationRoute.label.name}-${label.name}',
          NotesPage(label: label),
        );
      } else if (index == labels.length + 1) {
        NavigationRoute.manageLabels.pushOrGo(context, isHomeRoute(route), LabelsPage());
      } else if (index == labels.length + 2) {
        NavigationRoute.bin.pushOrGo(context, isHomeRoute(route), BinPage());
      } else if (index == labels.length + 3) {
        NavigationRoute.settings.pushOrGo(context, isHomeRoute(route), SettingsMainPage());
      } else {
        throw Exception('Invalid drawer indexes while navigating to a new route: $index');
      }
    }

    // The labels are disabled
    else {
      switch (index) {
        case 0:
          Navigator.pop(context);
        case 1:
          NavigationRoute.bin.pushOrGo(context, isHomeRoute(route), BinPage());
        case 2:
          NavigationRoute.settings.pushOrGo(context, isHomeRoute(route), SettingsMainPage());
        default:
          throw Exception('Unknown index while navigating: $index');
      }
    }

    setState(() {
      _index = index;
    });
  }

  /// Returns the navigation drawer.
  Widget drawer(BuildContext context, [List<Label>? labels]) {
    return NavigationDrawer(
      onDestinationSelected: (index) => navigate(index, labels),
      selectedIndex: _index,
      children: <Widget>[
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Asset.icon.path,
                fit: BoxFit.fitWidth,
                width: Sizes.iconSize.size,
              ),
              Padding(padding: Paddings.vertical(8)),
              Text(
                l.app_name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        NavigationDrawerDestination(
          key: Keys.drawerNotesTab,
          icon: const Icon(Icons.notes_outlined),
          selectedIcon: const Icon(Icons.notes),
          label: Text(l.navigation_notes),
        ),
        if (labels != null) ...[
          Divider(indent: 24, endIndent: 24),
          for (final label in labels)
            NavigationDrawerDestination(
              icon: Icon(
                label.pinned ? Icons.label_important_outline : Icons.label_outline,
                color: label.color,
              ),
              selectedIcon: Icon(
                label.pinned ? Icons.label_important : Icons.label,
                color: label.color,
              ),
              label: Expanded(
                child: Text(
                  label.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
        if (labels != null) ...[
          NavigationDrawerDestination(
            icon: const Icon(Symbols.auto_label),
            selectedIcon: VariedIcon.varied(Symbols.auto_label, fill: 1.0),
            label: Text(l.navigation_manage_labels_destination),
          ),
          Divider(indent: 24, endIndent: 24),
        ],
        NavigationDrawerDestination(
          key: Keys.drawerNotesTab,
          icon: const Icon(Icons.delete_outline),
          selectedIcon: const Icon(Icons.delete),
          label: Text(l.navigation_bin),
        ),
        // Divider(indent: 24, endIndent: 24),
        NavigationDrawerDestination(
          key: Keys.drawerSettingsTab,
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: Text(l.navigation_settings),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final enableLabels = PreferenceKey.enableLabels.getPreferenceOrDefault();

    if (enableLabels) {
      return ref.watch(labelsNavigationProvider).when(
        data: (labels) {
          setIndex(labels);

          return drawer(context, labels);
        },
        error: (exception, stackTrace) {
          return ErrorPlaceholder(exception: exception, stackTrace: stackTrace);
        },
        loading: () {
          return drawer(context);
        },
      );
    } else {
      setIndex();

      return drawer(context);
    }
  }
}
