import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checklist/checklist.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/actions/labels/select.dart';
import 'common/actions/notes/select.dart';
import 'common/constants/constants.dart';
import 'common/enums/supported_language.dart';
import 'common/extensions/locale_extension.dart';
import 'common/preferences/preference_key.dart';
import 'common/system_utils.dart';
import 'common/ui/theme_utils.dart';
import 'l10n/app_localizations/app_localizations.g.dart';
import 'models/note/note_status.dart';
import 'navigation/router.dart';
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

  /// Called when the application goes to the background or the foreground.
  void onFGBGEvent(FGBGType value) {
    switch (value) {
      case FGBGType.background:
        lastForegroundTimestamp = DateTime.timestamp();
      case FGBGType.foreground:
        final now = DateTime.timestamp();

        // Application lock
        final lockApp = PreferenceKey.lockApp.preferenceOrDefault;
        if (lockApp) {
          final lockAppDelayPreference = PreferenceKey.lockAppDelay.preferenceOrDefault;

          if (lockAppDelayPreference != -1) {
            final lockAppDelay = Duration(seconds: lockAppDelayPreference);
            final timeSinceBackground = now.difference(lastForegroundTimestamp);
            if (timeSinceBackground > lockAppDelay) {
              lockAppNotifier.lock();
            }
          }
        }

        // Note lock (it doesn't matter if the note itself should not be locked, it just triggers a rebuild)
        final lockNote = PreferenceKey.lockNote.preferenceOrDefault;
        final lockLabel = PreferenceKey.lockLabel.preferenceOrDefault;
        if (lockNote || lockLabel) {
          final lockNoteDelayPreference = PreferenceKey.lockNoteDelay.preferenceOrDefault;

          if (lockNoteDelayPreference != -1) {
            final lockNoteDelay = Duration(seconds: PreferenceKey.lockNoteDelay.preferenceOrDefault);
            final timeSinceBackground = now.difference(lastForegroundTimestamp);
            if (timeSinceBackground > lockNoteDelay) {
              lockNoteNotifier.lock();
            }
          }
        }
    }
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

    return DynamicColorBuilder(
      builder: (lightDynamicColorScheme, darkDynamicColorScheme) {
        final lightTheme = ThemeUtils().getLightTheme(lightDynamicColorScheme, dynamicTheming, appFont);
        final darkTheme = ThemeUtils().getDarkTheme(
          darkDynamicColorScheme,
          dynamicTheming,
          blackTheming,
          appFont,
          useWhiteTextDarkMode,
        );

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScaling)),
          child: Directionality(
            textDirection: SystemUtils().deviceLocale.textDirection,
            child: FGBGNotifier(
              onEvent: onFGBGEvent,
              child: MaterialApp.router(
                title: 'Material Notes',
                routerConfig: router,
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
            ),
          ),
        );
      },
    );
  }
}
