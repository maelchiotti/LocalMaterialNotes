import 'package:flutter/material.dart' hide Route;
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/routing/routes/bin/bin_route.dart';
import 'package:localmaterialnotes/routing/routes/labels/labels_route.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_about_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_appearance_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_backup_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_behavior_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/settings/settings_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';

/// Extends the [GoRouter] class with some utilities functions.
extension BuildContextExtension on BuildContext {
  /// Returns the path of the current location of the application's router.
  String get location {
    return GoRouterState.of(this).uri.path;
  }

  /// Returns the query parameters of the current location of the application's router.
  Map<String, String> get queryParameters {
    return GoRouterState.of(this).uri.queryParameters;
  }

  /// Returns the title of the current location of the application's router.
  String title(BuildContext context) {
    if (location == NotesRoute().location) {
      // Notes list
      if (context.queryParameters.isEmpty) {
        return l.navigation_notes;
      }
      // Notes list with a filter on a label
      else {
        final labelName = context.queryParameters['label-name'];

        if (labelName == null) {
          throw Exception('The label name is null in the notes app bar');
        }

        return labelName;
      }
    } else if (location == LabelsRoute().location) {
      return 'Labels';
    } else if (location == BinRoute().location) {
      return l.navigation_bin;
    } else if (location == SettingsRoute().location) {
      return l.navigation_settings;
    } else if (location == SettingsAppearanceRoute().location) {
      return l.navigation_settings_appearance;
    } else if (location == SettingsBehaviorRoute().location) {
      return l.navigation_settings_behavior;
    } else if (location == SettingsEditorRoute().location) {
      return l.navigation_settings_editor;
    } else if (location == SettingsBackupRoute().location) {
      return l.navigation_settings_backup;
    } else if (location == SettingsAboutRoute().location) {
      return l.navigation_settings_about;
    } else {
      throw Exception('Unexpected route while getting its title: $location');
    }
  }
}
