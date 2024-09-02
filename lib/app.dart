import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/locale_extension.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/routing/router.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';
import 'package:localmaterialnotes/utils/quick_actions_utils.dart';
import 'package:localmaterialnotes/utils/share_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';

/// MaterialNotes application.
class App extends ConsumerStatefulWidget {
  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with AfterLayoutMixin<App> {
  /// Stream of data shared from other applications.
  late StreamSubscription _stream;

  @override
  void initState() {
    super.initState();

    // Read the potential data shared from other applications
    readSharedData(ref);
    _stream = listenSharedData(ref);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // When the app is built, initialize the quick actions
    QuickActionsUtils().ensureInitialized(rootNavigatorKey.currentContext!, ref);
  }

  @override
  void dispose() {
    _stream.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamicColorScheme, darkDynamicColorScheme) {
        return ValueListenableBuilder(
          valueListenable: dynamicThemingNotifier,
          builder: (context, dynamicTheming, child) {
            return ValueListenableBuilder(
              valueListenable: blackThemingNotifier,
              builder: (context, blackTheming, child) {
                return ValueListenableBuilder(
                  valueListenable: themeModeNotifier,
                  builder: (context, themeMode, child) {
                    return MaterialApp.router(
                      title: 'Material Notes',
                      routerConfig: router,
                      builder: (context, child) {
                        if (child == null) {
                          throw Exception('MaterialApp child is null');
                        }

                        return Directionality(
                          textDirection: LocaleUtils().deviceLocale.textDirection,
                          child: child,
                        );
                      },
                      theme: ThemeUtils().getLightTheme(lightDynamicColorScheme),
                      darkTheme: ThemeUtils().getDarkTheme(darkDynamicColorScheme),
                      themeMode: themeMode,
                      localizationsDelegates: AppLocalizations.localizationsDelegates,
                      supportedLocales: AppLocalizations.supportedLocales,
                      locale: LocaleUtils().appLocale,
                      debugShowCheckedModeBanner: false,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
