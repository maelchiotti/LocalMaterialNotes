import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../models/label/label.dart';
import '../../navigation/navigation_routes.dart';
import '../../providers/labels/labels_navigation/labels_navigation_provider.dart';
import '../constants/constants.dart';
import '../constants/paddings.dart';
import '../constants/sizes.dart';
import '../preferences/preference_key.dart';
import '../widgets/asset.dart';

/// Side navigation with the drawer.
class SideNavigation extends ConsumerStatefulWidget {
  /// Default constructor.
  const SideNavigation({super.key});

  @override
  ConsumerState<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends ConsumerState<SideNavigation> {
  /// Index of the currently selected drawer destination.
  late int index;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setIndex();
  }

  /// Sets the index of the navigation drawer.
  void setIndex() {
    final route = ModalRoute.of(context)?.settings.name;

    assert(route != null, 'Missing current route while navigating');
    route!;

    final enableLabels = PreferenceKey.enableLabels.preferenceOrDefault;

    if (enableLabels) {
      final labels = ref.read(labelsNavigationProvider).value ?? [];

      if (route == NavigationRoute.notes.name) {
        index = 0;
      } else if (route == NavigationRoute.labels.name) {
        index = labels.length + 1;
      } else if (route == NavigationRoute.archives.name) {
        index = labels.length + 2;
      } else if (route == NavigationRoute.bin.name) {
        index = labels.length + 3;
      } else if (route == NavigationRoute.settings.name) {
        index = labels.length + 4;
      } else if (labels.isNotEmpty) {
        labels.forEachIndexed((label, labelIndex) {
          if (route == NavigationRoute.getLabelRouteName(label)) {
            index = labelIndex + 1;
          }
        });
      } else {
        throw Exception('Unknown route when setting the side navigation index: $route');
      }
    } else {
      if (route == NavigationRoute.notes.name) {
        index = 0;
      } else if (route == NavigationRoute.archives.name) {
        index = 1;
      } else if (route == NavigationRoute.bin.name) {
        index = 2;
      } else if (route == NavigationRoute.settings.name) {
        index = 3;
      }
    }
  }

  /// Navigates to the route corresponding to the [newIndex].
  void navigate(int newIndex) {
    // If the new route is the same as the current one, just close the drawer
    if (index == newIndex) {
      Navigator.pop(context);

      return;
    }

    // Close the navigation drawer
    Navigator.pop(context);

    final enableLabels = PreferenceKey.enableLabels.preferenceOrDefault;

    if (enableLabels) {
      final labels = ref.read(labelsNavigationProvider).value ?? [];

      if (newIndex == 0) {
        context.goNamed(NavigationRoute.notes.name);
      } else if (newIndex == labels.length + 1) {
        context.goNamed(NavigationRoute.labels.name);
      } else if (newIndex == labels.length + 2) {
        context.goNamed(NavigationRoute.archives.name);
      } else if (newIndex == labels.length + 3) {
        context.goNamed(NavigationRoute.bin.name);
      } else if (newIndex == labels.length + 4) {
        context.goNamed(NavigationRoute.settings.name);
      } else if (labels.isNotEmpty) {
        labels.forEachIndexed((label, index) {
          if (newIndex == index + 1) {
            context.goNamed(NavigationRoute.getLabelRouteName(label));
          }
        });
      } else {
        throw Exception('Unknown new side navigation index: $newIndex');
      }
    } else {
      switch (newIndex) {
        case 0:
          context.goNamed(NavigationRoute.notes.name);
        case 1:
          context.goNamed(NavigationRoute.archives.name);
        case 2:
          context.goNamed(NavigationRoute.bin.name);
        case 3:
          context.goNamed(NavigationRoute.settings.name);
        default:
          throw Exception('Unknown new side navigation index: $newIndex');
      }
    }

    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final enableLabels = PreferenceKey.enableLabels.preferenceOrDefault;
    List<Label> labels = [];
    if (enableLabels) {
      labels = ref.read(labelsNavigationProvider).value ?? [];
    }

    return NavigationDrawer(
      onDestinationSelected: navigate,
      selectedIndex: index,
      children: <Widget>[
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Asset.icon.path, fit: BoxFit.fitWidth, width: Sizes.appIcon.size),
              Padding(padding: Paddings.vertical(8)),
              Text(l.app_name, style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.notes_outlined),
          selectedIcon: const Icon(Icons.notes),
          label: Text(l.navigation_notes),
        ),
        Divider(indent: 24, endIndent: 24),
        if (enableLabels) ...[
          for (final label in labels)
            NavigationDrawerDestination(
              icon: Icon(label.pinned ? Icons.label_important_outline : Icons.label_outline, color: label.color),
              selectedIcon: Icon(label.pinned ? Icons.label_important : Icons.label, color: label.color),
              label: Expanded(child: Text(label.name, maxLines: 2, overflow: TextOverflow.ellipsis)),
            ),
          NavigationDrawerDestination(
            icon: const Icon(Symbols.auto_label),
            selectedIcon: VariedIcon.varied(Symbols.auto_label, fill: 1.0),
            label: Text(l.navigation_manage_labels_destination),
          ),
          Divider(indent: 24, endIndent: 24),
        ],
        NavigationDrawerDestination(
          icon: const Icon(Icons.archive_outlined),
          selectedIcon: const Icon(Icons.archive),
          label: Text(l.navigation_archives),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.delete_outline),
          selectedIcon: const Icon(Icons.delete),
          label: Text(l.navigation_bin),
        ),
        Divider(indent: 24, endIndent: 24),
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: Text(l.navigation_settings),
        ),
      ],
    );
  }
}
