// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/common/widgets/fabs/fab_add_note.dart';
import 'package:localmaterialnotes/common/widgets/fabs/fab_empty_bin.dart';
import 'package:localmaterialnotes/common/widgets/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/widgets/navigation/app_bars/editor_app_bar.dart';
import 'package:localmaterialnotes/common/widgets/navigation/app_bars/notes_app_bar.dart';
import 'package:localmaterialnotes/common/widgets/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/widgets/navigation/top_navigation.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_appearance_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';
import 'package:localmaterialnotes/utils/keys.dart';

import '../../routing/routes/bin/bin_route.dart';
import '../../routing/routes/settings/settings_about_route.dart';
import '../../routing/routes/settings/settings_backup_route.dart';
import '../../routing/routes/settings/settings_behavior_route.dart';
import '../../routing/routes/settings/settings_editor_route.dart';
import '../../routing/routes/settings/settings_route.dart';

/// Shell that contains the current page, the app bar, the drawer and the FAB.
class ShellPage extends StatefulWidget {
  /// Default constructor.
  const ShellPage({
    super.key,
    required this.child,
  });

  /// Page to show.
  final Widget child;

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  /// Returns the app bar to use depending on the current route.
  PreferredSizeWidget? get _appBar {
    if (context.location == NotesRoute().location || context.location == BinRoute().location) {
      return const TopNavigation(
        appbar: NotesAppBar(
          key: Keys.appBarNotesBin,
        ),
      );
    } else if (context.location == const NotesEditorRoute.empty().location) {
      return const TopNavigation(
        key: Keys.appBarEditor,
        appbar: EditorAppBar(),
      );
    } else if (context.location == SettingsRoute().location) {
      return const TopNavigation(
        key: Keys.appBarSettingsMain,
        appbar: BasicAppBar(),
      );
    } else if (context.location == SettingsAppearanceRoute().location ||
        context.location == SettingsBehaviorRoute().location ||
        context.location == SettingsEditorRoute().location ||
        context.location == SettingsBackupRoute().location ||
        context.location == SettingsAboutRoute().location) {
      return const TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar.back(),
      );
    } else {
      return null;
    }
  }

  /// Returns the drawer to use depending on the current route.
  Widget? get _drawer {
    if (context.location == NotesRoute().location ||
        context.location == BinRoute().location ||
        context.location == SettingsRoute().location) {
      return const SideNavigation();
    } else {
      return null;
    }
  }

  /// Returns the floating action button to use depending on the current route.
  Widget? get _floatingActionButton {
    if (context.location == NotesRoute().location) {
      return const FabAddNote(
        key: Keys.fabAddNote,
      );
    } else if (context.location == BinRoute().location) {
      return const FabEmptyBin(
        key: Keys.fabEmptyBin,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      drawer: _drawer,
      body: widget.child,
      floatingActionButton: _floatingActionButton,
    );
  }
}
