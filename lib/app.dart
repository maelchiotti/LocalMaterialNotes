import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/locale_extension.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/providers/labels/labels_list/labels_list_provider.dart';
import 'package:localmaterialnotes/providers/labels/labels_navigation/labels_navigation_provider.dart';
import 'package:localmaterialnotes/providers/preferences/preferences_provider.dart';
import 'package:localmaterialnotes/routing/router.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';
import 'package:localmaterialnotes/utils/quick_actions_utils.dart';
import 'package:localmaterialnotes/utils/share_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';

/// MaterialNotes application.
class App extends ConsumerStatefulWidget {
  /// Default constructor.
  const App({super.key});

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

    // Eagerly get the labels for the full list and the navigation
    ref.read(labelsListProvider.notifier).get();
    ref.read(labelsNavigationProvider.notifier).get();
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
    final themeMode = ref.watch(preferencesProvider.select((preferences) => preferences.themeMode));
    final blackTheming = ref.watch(preferencesProvider.select((preferences) => preferences.blackTheming));
    final dynamicTheming = ref.watch(preferencesProvider.select((preferences) => preferences.dynamicTheming));
    final textScaling = ref.watch(preferencesProvider.select((preferences) => preferences.textScaling));
    final useWhiteTextDarkMode =
        ref.watch(preferencesProvider.select((preferences) => preferences.useWhiteTextDarkMode));

    return DynamicColorBuilder(
      builder: (lightDynamicColorScheme, darkDynamicColorScheme) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaling),
          ),
          child: MaterialApp.router(
            title: 'Material Notes',
            routerConfig: router,
            builder: (context, child) {
              // Change the widget shown when a widget building fails
              ErrorWidget.builder = (errorDetails) => ErrorPlaceholder.errorDetails(errorDetails);

              if (child == null) {
                throw StateError('MaterialApp child is null');
              }

              return Directionality(
                textDirection: LocaleUtils().deviceLocale.textDirection,
                child: child,
              );
            },
            theme: ThemeUtils().getLightTheme(lightDynamicColorScheme, dynamicTheming),
            darkTheme: ThemeUtils().getDarkTheme(
              darkDynamicColorScheme,
              dynamicTheming,
              blackTheming,
              useWhiteTextDarkMode,
            ),
            themeMode: themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: LocaleUtils().appLocale,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
