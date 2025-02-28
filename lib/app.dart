import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_checklist/checklist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/actions/labels/select.dart';
import 'common/actions/notes/select.dart';
import 'common/constants/constants.dart';
import 'common/enums/supported_language.dart';
import 'common/extensions/locale_extension.dart';
import 'common/preferences/preference_key.dart';
import 'common/system_utils.dart';
import 'common/ui/theme_utils.dart';
import 'common/widgets/placeholders/error_placeholder.dart';
import 'l10n/app_localizations/app_localizations.g.dart';
import 'models/note/note_status.dart';
import 'pages/lock/lock_page.dart';
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

class _AppState extends ConsumerState<App> {
  /// Stream of data shared from other applications.
  late StreamSubscription _stream;

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(backButtonInterceptor);

    globalRef = ref;

    // Read the potential data shared from other applications
    SystemUtils().readSharedData(ref);
    _stream = SystemUtils().listenSharedData(ref);

    // Eagerly get the labels for the full list and the navigation
    ref.read(labelsListProvider.notifier).get();
    ref.read(labelsNavigationProvider.notifier).get();
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
      unselectAllNotes(context, ref, notesStatus: NoteStatus.available);
      unselectAllNotes(context, ref, notesStatus: NoteStatus.archived);
      unselectAllNotes(context, ref, notesStatus: NoteStatus.deleted);
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
    final useWhiteTextDarkMode = ref.watch(
      preferencesProvider.select((preferences) => preferences.useWhiteTextDarkMode),
    );
    final lockApp = PreferenceKey.lockApp.preferenceOrDefault;
    final lockAppDelay = PreferenceKey.lockAppDelay.preferenceOrDefault;

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
            home: NotesPage(label: null),
            navigatorKey: rootNavigatorKey,
            builder: (context, child) {
              // Change the widget shown when a widget building fails
              ErrorWidget.builder = (errorDetails) => ErrorPlaceholder.errorDetails(errorDetails);

              if (child == null) {
                throw Exception('MaterialApp child is null');
              }

              return Directionality(
                textDirection: SystemUtils().deviceLocale.textDirection,
                child: lockApp
                    ? AppLock(
                        initiallyEnabled: lockApp,
                        initialBackgroundLockLatency: Duration(seconds: lockAppDelay),
                        builder: (BuildContext context, Object? launchArg) {
                          SystemUtils().setQuickActions(context, ref);

                          return child;
                        },
                        lockScreenBuilder: (BuildContext context) {
                          final l = AppLocalizations.of(context);

                          return LockPage(
                            back: false,
                            description: l.lock_page_description_app,
                            reason: l.lock_page_reason_app,
                          );
                        },
                      )
                    : child,
              );
            },
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            localizationsDelegates: [
              ...AppLocalizations.localizationsDelegates,
              ChecklistLocalizations.delegate,
              FleatherLocalizations.delegate,
            ],
            supportedLocales: SupportedLanguage.locales,
            locale: SystemUtils().appLocale,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}
