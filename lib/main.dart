import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'common/localization/localizations_utils.dart';
import 'common/logs/app_logger.dart';
import 'common/preferences/preferences_utils.dart';
import 'common/system/flag_secure_utils.dart';
import 'common/system/info_utils.dart';
import 'common/ui/theme_utils.dart';
import 'services/backup/auto_backup_service.dart';
import 'services/database_service.dart';

/// Main entry point of the application.
Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keep the splash screen until all initializations are done
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Display the application behind the system's notifications bar and navigation bar
  // See https://github.com/flutter/flutter/issues/40974
  // See https://github.com/flutter/flutter/issues/34678
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Initialize the utilities
  await AppLogger().ensureInitialized();
  await PreferencesUtils().ensureInitialized();
  await InfoUtils().ensureInitialized();
  await LocalizationsUtils().ensureInitialized();
  await ThemeUtils().ensureInitialized();

  // Set the application refresh rate (only in Android 6 or later)
  // See https://github.com/flutter/flutter/issues/35162
  if (InfoUtils().androidVersion >= 23) {
    await FlutterDisplayMode.setHighRefreshRate();
  }

  // Initialize the database service
  await DatabaseService().ensureInitialized();

  // No need to await this, it can be performed in the background
  AutoExportUtils().ensureInitialized();

  // Set FLAG_SECURE if needed
  await setFlagSecureIfNeeded();

  // Remove the splash screen
  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}
