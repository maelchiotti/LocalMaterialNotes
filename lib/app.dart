import 'dart:async';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/routing/router.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/pages/authentication/authentication_page.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/locale_manager.dart';
import 'package:localmaterialnotes/utils/preferences/lock_latency.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';
import 'package:localmaterialnotes/utils/share_manager.dart';
import 'package:localmaterialnotes/utils/theme_manager.dart';

class App extends ConsumerStatefulWidget {
  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late StreamSubscription _stream;

  @override
  void initState() {
    super.initState();

    readSharedData(ref);
    _stream = listenSharedData(ref);
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
                      builder: (_, child) {
                        final lockPreference = PreferencesManager().get<bool>(PreferenceKey.lock);
                        final lock = lockPreference ?? PreferenceKey.lock.defaultValue! as bool;

                        final lockLatencyPreference = PreferencesManager().get<String>(PreferenceKey.lockLatency);
                        final lockLatency = lockLatencyPreference != null
                            ? LockLatency.values.byName(lockLatencyPreference)
                            : PreferenceKey.lockLatency.defaultValue! as LockLatency;

                        return AppLock(
                          builder: (_, __) => child!,
                          lockScreenBuilder: (_) => const AuthenticationPage(),
                          enabled: lock,
                          backgroundLockLatency: Duration(minutes: lockLatency.minutes),
                        );
                      },
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
