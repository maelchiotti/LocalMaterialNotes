import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:localmaterialnotes/app.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/navigation/navigation_routes.dart';
import 'package:localmaterialnotes/pages/bin/bin_page.dart';
import 'package:localmaterialnotes/pages/settings/settings_main_page.dart';
import 'package:localmaterialnotes/services/labels/labels_service.dart';
import 'package:localmaterialnotes/services/notes/notes_service.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/flag_secure_utils.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';
import 'package:patrol/patrol.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> get app async {
  // Mock the preferences
  SharedPreferences.setMockInitialValues({});

  // Initialize the utilities
  await PreferencesUtils().ensureInitialized();
  await InfoUtils().ensureInitialized();
  await ThemeUtils().ensureInitialized();

  // Initialize the services
  await NotesService().ensureInitialized();
  await LabelsService().ensureInitialized();

  // No need to await this, it can be performed in the background
  AutoExportUtils().ensureInitialized();

  // Set FLAG_SECURE if needed
  await setFlagSecureIfNeeded();

  return ProviderScope(
    child: App(),
  );
}

Future<void> openBin(PatrolIntegrationTester $) async {
  NavigationRoute.bin.push(rootNavigatorKey.currentContext!, BinPage());
  await $.pumpAndSettle();
}

Future<void> openSettingsMain(PatrolIntegrationTester $) async {
  NavigationRoute.settings.push(rootNavigatorKey.currentContext!, SettingsMainPage());
  await $.pumpAndSettle();
}
