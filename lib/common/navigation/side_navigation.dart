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
  int index = RouterRoute.currentDrawerIndex;

  void _navigate(int newIndex) {
    setState(() {
      index = newIndex;
    });

    context.go(RouterRoute.getRouteFromIndex(index).path);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: _navigate,
      selectedIndex: index,
      children: <Widget>[
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Asset.icons.path,
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
