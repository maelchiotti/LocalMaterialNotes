import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/app.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/services/notes/notes_service.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/flag_secure_utils.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';

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

  // Set the application refresh rate
  // See https://github.com/flutter/flutter/issues/35162
  await FlutterDisplayMode.setHighRefreshRate();

  // Initialize the utilities
  await PreferencesUtils().ensureInitialized();
  await InfoUtils().ensureInitialized();
  await ThemeUtils().ensureInitialized();

  // Initialize the services
  await NotesService().ensureInitialized();

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
