import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/routing/router.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/locale_manager.dart';
import 'package:localmaterialnotes/utils/quick_actions_manager.dart';
import 'package:localmaterialnotes/utils/share_manager.dart';
import 'package:localmaterialnotes/utils/theme_manager.dart';

class App extends ConsumerStatefulWidget {
  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with AfterLayoutMixin<App> {
  late StreamSubscription _stream;

  @override
  void initState() {
    super.initState();

    readSharedData(ref);
    _stream = listenSharedData(ref);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    QuickActionsManager().init(navigatorKey.currentContext!, ref);
  }

  @override
  void dispose() {
    _stream.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return ValueListenableBuilder(
          valueListenable: dynamicThemingNotifier,
          builder: (_, __, ___) {
            return ValueListenableBuilder(
              valueListenable: blackThemingNotifier,
              builder: (_, __, ___) {
                return ValueListenableBuilder(
                  valueListenable: themeModeNotifier,
                  builder: (_, themeMode, ___) {
                    final useDynamicTheming = ThemeManager().useDynamicTheming;

                    return MaterialApp.router(
                      title: 'Material Notes',
                      theme: useDynamicTheming
                          ? ThemeManager().getLightDynamicTheme(lightDynamic)
                          : ThemeManager().getLightCustomTheme,
                      darkTheme: useDynamicTheming
                          ? ThemeManager().getDarkDynamicTheme(darkDynamic)
                          : ThemeManager().getDarkCustomTheme,
                      themeMode: themeMode,
                      localizationsDelegates: const [
                        ...AppLocalizations.localizationsDelegates,
                      ],
                      supportedLocales: AppLocalizations.supportedLocales,
                      locale: LocaleManager().locale,
                      routerConfig: router,
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
