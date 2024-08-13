import 'package:flutter/material.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/hardcoded_localizations_utils.dart';
import 'package:parchment/codecs.dart'; // ignore: depend_on_referenced_packages

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root navigator key');
final drawerKey = GlobalKey<ScaffoldState>(debugLabel: 'Drawer key');

final localizations = AppLocalizations.of(navigatorKey.currentContext!);
final hardcodedLocalizations = HardcodedLocalizationsUtils();

const parchmentMarkdownCodec = ParchmentMarkdownCodec();

final editorFocusNode = FocusNode(debugLabel: 'Editor focus node');
