import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/common/widgets/fabs/fab_add_note.dart';
import 'package:localmaterialnotes/common/widgets/fabs/fab_empty_bin.dart';
import 'package:localmaterialnotes/common/widgets/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/widgets/navigation/app_bars/editor_app_bar.dart';
import 'package:localmaterialnotes/common/widgets/navigation/app_bars/notes_app_bar.dart';
import 'package:localmaterialnotes/common/widgets/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/widgets/navigation/top_navigation.dart';
import 'package:localmaterialnotes/routing/routes/routing_route.dart';

class ShellPage extends StatefulWidget {
  const ShellPage(this.child, {super.key});

  final Widget child;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  /// Returns the app bar to use depending on the current route.
  PreferredSizeWidget? get _appBar {
    switch (context.route) {
      case RoutingRoute.notes:
      case RoutingRoute.bin:
        return const TopNavigation(
          appbar: NotesAppBar(),
        );
      case RoutingRoute.notesEditor:
        return const TopNavigation(
          appbar: EditorAppBar(),
        );
      case RoutingRoute.settings:
        return const TopNavigation(
          appbar: BasicAppBar(),
        );
      case RoutingRoute.settingsAppearance:
      case RoutingRoute.settingsBehavior:
      case RoutingRoute.settingsEditor:
      case RoutingRoute.settingsBackup:
      case RoutingRoute.settingsAbout:
        return const TopNavigation(
          appbar: BasicAppBar.back(),
        );
      default:
        return null;
    }
  }

  /// Returns the drawer to use depending on the current route.
  Widget? get _drawer {
    switch (context.route) {
      case RoutingRoute.notes:
      case RoutingRoute.bin:
      case RoutingRoute.settings:
        return const SideNavigation();
      default:
        return null;
    }
  }

  /// Returns the floating action button to use depending on the current route.
  Widget? get _floatingActionButton {
    switch (context.route) {
      case RoutingRoute.notes:
        return const FabAddNote();
      case RoutingRoute.bin:
        return const FabEmptyBin();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldDrawerKey,
      appBar: _appBar,
      drawer: _drawer,
      body: KeyboardVisibilityProvider(child: widget.child),
      floatingActionButton: _floatingActionButton,
    );
  }
}
