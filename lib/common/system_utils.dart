import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:listen_sharing_intent/listen_sharing_intent.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quick_actions/quick_actions.dart';

import '../l10n/app_localizations/app_localizations.g.dart';
import '../models/note/types/note_type.dart';
import 'actions/notes/add.dart';
import 'constants/constants.dart';
import 'extensions/build_context_extension.dart';
import 'preferences/preference_key.dart';

/// System utilities.
class SystemUtils {
  static final SystemUtils _singleton = SystemUtils._internal();

  /// Provides information about the system.
  factory SystemUtils() => _singleton;

  SystemUtils._internal();

  /// Information about the package.
  late final PackageInfo _packageInfo;

  /// Information about the Android device.
  late final AndroidDeviceInfo _androidDeviceInfo;

  /// Application localizations.
  late AppLocalizations _appLocalizations;

  /// Application's quick actions.
  late final QuickActions quickActions;

  /// Is system authentication available.
  late bool isSystemAuthenticationAvailable;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _androidDeviceInfo = await DeviceInfoPlugin().androidInfo;

    _appLocalizations = await AppLocalizations.delegate.load(appLocale);

    quickActions = const QuickActions();

    isSystemAuthenticationAvailable = await LocalAuthentication().isDeviceSupported();
  }

  /// version of the application.
  String get appVersion => _packageInfo.version;

  /// version of the application.
  int get buildNumber => int.parse(_packageInfo.buildNumber);

  /// Android version of the device.
  int get androidVersion => _androidDeviceInfo.version.sdkInt;

  /// Brand of the device
  String get brand => _androidDeviceInfo.brand;

  /// Model of the device.
  String get model => _androidDeviceInfo.model;

  /// Build mode of the application (either `release` or `debug`).
  String buildMode(BuildContext context) =>
      kReleaseMode ? context.l.settings_build_mode_release : context.l.settings_build_mode_debug;

  /// The name of the application.
  String get appName => _appLocalizations.app_name;

  /// Title of the welcome note.
  String get welcomeNoteTitle => _appLocalizations.welcome_note_title;

  /// Content of the welcome note.
  String get welcomeNoteContent => _appLocalizations.welcome_note_content;

  /// Locale of the device.
  Locale get deviceLocale {
    final localeCodes = Platform.localeName.split('-');
    final languageCode = localeCodes.first;
    String? countryCode;
    if (localeCodes.length == 2) {
      countryCode = localeCodes[1];
    }

    return Locale.fromSubtags(languageCode: languageCode, countryCode: countryCode);
  }

  /// Locale of the application.
  Locale get appLocale {
    final localeCodes = PreferenceKey.locale.preferenceOrDefault.split('-');
    final languageCode = localeCodes.first;
    String? scriptCode;
    if (localeCodes.length == 2) {
      scriptCode = localeCodes[1];
    }
    String? countryCode;
    if (localeCodes.length == 3) {
      countryCode = localeCodes[2];
    }

    return Locale.fromSubtags(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
  }

  /// Locale language code of the application.
  String get appLocaleLanguageCode => appLocale.languageCode;

  /// Sets the application's locale to [locale].
  Future<void> setLocale(Locale locale) async {
    await PreferenceKey.locale.set(locale.toLanguageTag());

    // Reset the hardcoded localizations
    _appLocalizations = await AppLocalizations.delegate.load(appLocale);
  }

  /// Sets `FLAG_SECURE` to `true` if the corresponding preference was enabled by the user.
  Future<void> setFlagSecureIfNeeded() async {
    if (PreferenceKey.flagSecure.preferenceOrDefault) {
      await FlagSecure.set();
    }
  }

  /// Sets the quick actions.
  void setQuickActions(BuildContext context) {
    final availableNotesTypes = NoteType.available;

    final addPlainTextNoteAction = ShortcutItem(
      type: 'add_plain_text_note',
      localizedTitle: context.l.quick_action_add_plain_text_note_title,
      icon: 'ic_text_fields',
    );
    final addMarkdownNoteAction = ShortcutItem(
      type: 'add_markdown_note',
      localizedTitle: context.l.quick_action_add_markdown_note_title,
      icon: 'ic_markdown',
    );
    final addRichTextNoteAction = ShortcutItem(
      type: 'add_rich_text_note',
      localizedTitle: context.l.quick_action_add_rich_text_note_title,
      icon: 'ic_format_paint',
    );
    final addChecklistNoteAction = ShortcutItem(
      type: 'add_checklist_note',
      localizedTitle: context.l.quick_action_add_checklist_note_title,
      icon: 'ic_checklist',
    );

    quickActions.initialize((action) {
      if (action == addPlainTextNoteAction.type) {
        addNote(context, globalRef, noteType: NoteType.plainText);
      } else if (action == addMarkdownNoteAction.type) {
        addNote(context, globalRef, noteType: NoteType.markdown);
      } else if (action == addRichTextNoteAction.type) {
        addNote(context, globalRef, noteType: NoteType.richText);
      } else if (action == addChecklistNoteAction.type) {
        addNote(context, globalRef, noteType: NoteType.checklist);
      }
    });

    quickActions.setShortcutItems([
      if (availableNotesTypes.contains(NoteType.plainText)) addPlainTextNoteAction,
      if (availableNotesTypes.contains(NoteType.markdown)) addMarkdownNoteAction,
      if (availableNotesTypes.contains(NoteType.richText)) addRichTextNoteAction,
      if (availableNotesTypes.contains(NoteType.checklist)) addChecklistNoteAction,
    ]);
  }

  /// Listens to any data shared from other applications.
  StreamSubscription listenSharedData() {
    return ReceiveSharingIntent.instance.getMediaStream().listen((data) {
      _processSharedData(data);
    });
  }

  /// Reads the data shared from other applications.
  void readSharedData() {
    ReceiveSharingIntent.instance.getInitialMedia().then((data) {
      _processSharedData(data);

      ReceiveSharingIntent.instance.reset();
    });
  }

  /// Processes the [data] shared from other applications.
  ///
  /// If the [data] is text, it's added to a new note that is then opened.
  void _processSharedData(List<SharedMediaFile> data) {
    if (rootNavigatorKey.currentContext == null ||
        data.isEmpty ||
        data.first.type != SharedMediaType.text ||
        data.first.path.isEmpty) {
      return;
    }

    final defaultShortcutNoteType = NoteType.defaultShare;
    final context = rootNavigatorKey.currentContext!;
    final content = data.first.path;

    addNote(context, globalRef, noteType: defaultShortcutNoteType, content: content);
  }

  /// Encodes the query [parameters] to be used in an URI.
  String? encodeQueryParameters(Map<String, String> parameters) => parameters.entries
      .map((MapEntry<String, String> e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');

  /// Closes the keyboard.
  void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
