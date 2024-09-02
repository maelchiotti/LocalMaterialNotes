import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/routing/routes/bin/bin_route.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_route.dart';
import 'package:localmaterialnotes/routing/routes/routing_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';
import 'package:localmaterialnotes/utils/asset.dart';

/// Side navigation with the drawer.
class SideNavigation extends StatefulWidget {
  const SideNavigation();

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  /// Index of the currently selected drawer index.
  late int _index;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    switch (context.route) {
      case RoutingRoute.notes:
        _index = 0;
      case RoutingRoute.bin:
        _index = 1;
      case RoutingRoute.settings:
        _index = 2;
      default:
    }
  }

  /// Navigates to the route corresponding to the [index].
  void _navigate(int index) {
    // If the new route is the same as the current one, just close the drawer
    if (_index == index) {
      Navigator.pop(context);

      return;
    }

    switch (index) {
      case 0:
        NotesRoute().go(context);
      case 1:
        BinRoute().go(context);
      case 2:
        SettingsRoute().push(context);
      default:
        throw Exception('Invalid drawer index while navigating to a new route: $index');
    }

    Navigator.pop(context);

    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: _navigate,
      selectedIndex: _index,
      children: <Widget>[
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Asset.icon.path,
                fit: BoxFit.fitWidth,
                width: Sizes.size64.size,
              ),
              Padding(padding: Paddings.padding8.vertical),
              Text(
                localizations.app_name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.notes_outlined),
          selectedIcon: const Icon(Icons.notes),
          label: Text(localizations.navigation_notes),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.delete_outline),
          selectedIcon: const Icon(Icons.delete),
          label: Text(localizations.navigation_bin),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: Text(localizations.navigation_settings),
        ),
      ],
    );
  }
}
