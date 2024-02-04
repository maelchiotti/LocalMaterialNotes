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
  late int index;

  @override
  void initState() {
    super.initState();

    switch (RouterRoute.currentRoute) {
      case RouterRoute.notes:
      case RouterRoute.editor:
        index = 0;
      case RouterRoute.bin:
        index = 1;
      case RouterRoute.settings:
        index = 2;
      default:
        throw Exception();
    }
  }

  void _navigate(int newIndex) {
    setState(() {
      index = newIndex;
    });

    switch (index) {
      case 0:
        context.go(RouterRoute.notes.path);
      case 1:
        context.go(RouterRoute.bin.path);
      case 2:
        context.go(RouterRoute.settings.path);
      default:
        throw Exception();
    }

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
