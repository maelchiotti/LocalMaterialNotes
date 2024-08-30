import 'package:flutter/material.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/hardcoded_localizations_utils.dart';
import 'package:parchment/codecs.dart';

/// Key of the application's root navigator.
final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root navigator key');

/// Key of the application's drawer.
final drawerKey = GlobalKey<ScaffoldState>(debugLabel: 'Drawer key');

/// Application's localizations.
final localizations = AppLocalizations.of(navigatorKey.currentContext!);

/// Application's hardcoded localizations.
final hardcodedLocalizations = HardcodedLocalizationsUtils();

/// Codec to encode and decode Markdown files in fleather.
const parchmentMarkdownCodec = ParchmentMarkdownCodec();

/// Focus node of the note content text editor.
final editorFocusNode = FocusNode(debugLabel: 'Editor focus node');
