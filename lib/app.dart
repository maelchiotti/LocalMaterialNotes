import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/actions/labels/select.dart';
import 'common/actions/notes/select.dart';
import 'common/constants/constants.dart';
import 'common/enums/localization_completion.dart';
import 'common/extensions/locale_extension.dart';
import 'common/localization/locale_utils.dart';
import 'common/system/quick_actions_utils.dart';
import 'common/system/share_utils.dart';
import 'common/ui/theme_utils.dart';
import 'common/widgets/placeholders/error_placeholder.dart';
import 'l10n/app_localizations/app_localizations.g.dart';
import 'pages/notes/notes_page.dart';
import 'providers/labels/labels_list/labels_list_provider.dart';
import 'providers/labels/labels_navigation/labels_navigation_provider.dart';
import 'providers/notifiers/notifiers.dart';
import 'providers/preferences/preferences_provider.dart';

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

    BackButtonInterceptor.add(backButtonInterceptor);

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
    BackButtonInterceptor.remove(backButtonInterceptor);

    _stream.cancel();

    super.dispose();
  }

  /// Intercepts the back button.
  bool backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    var intercept = false;

    // Unselects all notes
    if (isNotesSelectionModeNotifier.value) {
      unselectAllNotes(context, ref);
      unselectAllNotes(context, ref, notesPage: false);
      isNotesSelectionModeNotifier.value = false;
      intercept = true;
    }

    // Unselects all labels
    if (isLabelsSelectionModeNotifier.value) {
      unselectAllLabels(ref);
      isLabelsSelectionModeNotifier.value = false;
      intercept = true;
    }

    return intercept;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(preferencesProvider.select((preferences) => preferences.themeMode));
    final blackTheming = ref.watch(preferencesProvider.select((preferences) => preferences.blackTheming));
    final dynamicTheming = ref.watch(preferencesProvider.select((preferences) => preferences.dynamicTheming));
    final appFont = ref.watch(preferencesProvider.select((preferences) => preferences.appFont));
    final textScaling = ref.watch(preferencesProvider.select((preferences) => preferences.textScaling));
    final useWhiteTextDarkMode =
        ref.watch(preferencesProvider.select((preferences) => preferences.useWhiteTextDarkMode));

    return DynamicColorBuilder(
      builder: (lightDynamicColorScheme, darkDynamicColorScheme) {
        final lightTheme = ThemeUtils().getLightTheme(
          lightDynamicColorScheme,
          dynamicTheming,
          appFont,
        );
        final darkTheme = ThemeUtils().getDarkTheme(
          darkDynamicColorScheme,
          dynamicTheming,
          blackTheming,
          appFont,
          useWhiteTextDarkMode,
        );

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaling),
          ),
          child: MaterialApp(
            title: 'Material Notes',
            home: NotesPage(),
            navigatorKey: rootNavigatorKey,
            builder: (context, child) {
              // Change the widget shown when a widget building fails
              ErrorWidget.builder = (errorDetails) => ErrorPlaceholder.errorDetails(errorDetails);

              assert(child != null, 'MaterialApp child is null');

              return Directionality(
                textDirection: LocaleUtils().deviceLocale.textDirection,
                child: child!,
              );
            },
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: SupportedLanguage.locales,
            locale: LocaleUtils().appLocale,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
