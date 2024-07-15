import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/app.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:localmaterialnotes/utils/flag_secure_utils.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Display the application behind the system's notifications bar and navigation bar
  // cf. https://github.com/flutter/flutter/issues/40974
  // cf. https://github.com/flutter/flutter/issues/34678
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // Set the application refresh rate
  // cf. https://github.com/flutter/flutter/issues/35162
  await FlutterDisplayMode.setHighRefreshRate();

  // Initialize all the utilities
  await PreferencesUtils().ensureInitialized();
  await InfoUtils().ensureInitialized();
  await ThemeUtils().ensureInitialized();
  await DatabaseUtils().ensureInitialized();

  // No need to await this, it can be performed in the background
  AutoExportUtils().ensureInitialized();

  // Set FLAG_SECURE if needed
  await setFlagSecureIfNeeded();

  FlutterNativeSplash.remove();

  runApp(
    ProviderScope(
      child: App(),
    ),
  );
}
