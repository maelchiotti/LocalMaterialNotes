import 'package:flutter/material.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/theme_manager.dart';
import 'package:parchment/codecs.dart'; // ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

final themeModeNotifier = ValueNotifier(ThemeManager().themeMode);
final dynamicThemingNotifier = ValueNotifier(ThemeManager().useDynamicTheming);
final blackThemingNotifier = ValueNotifier(ThemeManager().useBlackTheming);

final fleatherFieldHasFocusNotifier = ValueNotifier(false);

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root navigator key');
final drawerKey = GlobalKey<ScaffoldState>(debugLabel: 'Drawer key');

final localizations = AppLocalizations.of(navigatorKey.currentContext!)!;

const uuid = Uuid();

const parchmentMarkdownCodec = ParchmentMarkdownCodec();
