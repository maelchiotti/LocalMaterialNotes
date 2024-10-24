import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/providers/labels/labels_navigation/labels_navigation_provider.dart';
import 'package:localmaterialnotes/routing/routes/bin/bin_route.dart';
import 'package:localmaterialnotes/routing/routes/labels/labels_route.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';
import 'package:localmaterialnotes/utils/asset.dart';
import 'package:localmaterialnotes/utils/keys.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

/// Side navigation with the drawer.
class SideNavigation extends ConsumerStatefulWidget {
  /// Default constructor.
  const SideNavigation({super.key});

  @override
  ConsumerState<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends ConsumerState<SideNavigation> {
  /// Index of the currently selected drawer index.
  int _index = 0;

  void _setIndex(List<Label> labels) {
    super.didChangeDependencies();

    final labelsCount = labels.length;

    if (context.location == NotesRoute().location) {
      // Notes list
      if (context.queryParameters.isEmpty) {
        _index = 0;
      }
      // Notes list with a filter on a label
      else {
        final labelName = context.queryParameters['label-name'];
        final label = labels.firstWhere(
          (label) => label.name == labelName,
          orElse: () {
            throw Exception('Unknown label name in notes route query parameters: $labelName');
          },
        );

        _index = labels.indexOf(label) + 1;
      }
    } else if (context.location == LabelsRoute().location) {
      _index = labelsCount + 1;
    } else if (context.location == BinRoute().location) {
      _index = labelsCount + 2;
    } else if (context.location == SettingsRoute().location) {
      _index = labelsCount + 3;
    } else {
      throw Exception('Unexpected route while setting the drawer index: ${context.location}');
    }
  }

  /// Navigates to the route corresponding to the [index].
  void _navigate(int index, List<Label>? labels) {
    // If the new route is the same as the current one, just close the drawer
    if (_index == index) {
      Navigator.pop(context);

      return;
    }

    final labelsCount = labels?.length ?? 0;

    if (index == 0) {
      NotesRoute().go(context);
    } else if (index == labelsCount + 1) {
      LabelsRoute().go(context);
    } else if (index == labelsCount + 2) {
      BinRoute().go(context);
    } else if (index == labelsCount + 3) {
      SettingsRoute().push(context);
    } else if (index > 0 && index <= labelsCount) {
      NotesRoute(
        labelName: labels?[index - 1].name,
        $extra: labels?[index - 1],
      ).go(context);
    } else {
      throw Exception('Invalid drawer index while navigating to a new route: $index');
    }

    Navigator.pop(context);

    setState(() {
      _index = index;
    });
  }

  Widget child(BuildContext context, [List<Label>? labels]) {
    return NavigationDrawer(
      onDestinationSelected: (index) => _navigate(index, labels),
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
        Divider(indent: 24, endIndent: 24),
        if (labels != null)
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
        NavigationDrawerDestination(
          icon: const Icon(Symbols.auto_label),
          selectedIcon: VariedIcon.varied(Symbols.auto_label, fill: 1.0),
          label: Text('Manage labels'),
        ),
        Divider(indent: 24, endIndent: 24),
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
    return ref.watch(labelsNavigationProvider).when(
      data: (labels) {
        _setIndex(labels);

        return child(context, labels);
      },
      error: (exception, stackTrace) {
        return ErrorPlaceholder(exception: exception, stackTrace: stackTrace);
      },
      loading: () {
        return child(context);
      },
    );
  }
}
