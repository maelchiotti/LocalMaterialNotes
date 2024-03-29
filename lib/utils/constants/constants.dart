import 'package:flutter/material.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/theme_manager.dart';
import 'package:uuid/uuid.dart';

final themeModeNotifier = ValueNotifier(ThemeManager().themeMode);
final dynamicThemingNotifier = ValueNotifier(ThemeManager().useDynamicTheming);
final blackThemingNotifier = ValueNotifier(ThemeManager().useBlackTheming);

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root navigator key');
final drawerKey = GlobalKey<ScaffoldState>(debugLabel: 'Drawer key');

final localizations = AppLocalizations.of(navigatorKey.currentContext!)!;

const uuid = Uuid();
