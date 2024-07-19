import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/utils/asset.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';

class SideNavigation extends StatefulWidget {
  const SideNavigation();

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  int _index = RouterRoute.currentDrawerIndex;

  void _navigate(int newIndex) {
    // If the new route is the same as the current one, just close the drawer
    if (_index == newIndex) {
      Navigator.of(context).pop();

      return;
    }

    setState(() {
      _index = newIndex;
    });

    final newRoute = RouterRoute.getRouteFromIndex(_index);
    switch (newRoute) {
      case RouterRoute.settings:
        context.push(newRoute.path);
      default:
        context.go(newRoute.path);
    }

    Navigator.of(context).pop();
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
                filterQuality: FilterQuality.medium,
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
