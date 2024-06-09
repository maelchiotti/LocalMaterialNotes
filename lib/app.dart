import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/routing/router.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/locale_extension.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';
import 'package:localmaterialnotes/utils/quick_actions_utils.dart';
import 'package:localmaterialnotes/utils/share_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';

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
    QuickActionsUtils().init(navigatorKey.currentContext!, ref);
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
          builder: (_, __, ___) {
            return ValueListenableBuilder(
              valueListenable: blackThemingNotifier,
              builder: (_, __, ___) {
                return ValueListenableBuilder(
                  valueListenable: themeModeNotifier,
                  builder: (_, themeMode, ___) {
                    return MaterialApp.router(
                      title: 'Material Notes',
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
