import 'package:flutter/material.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/hardcoded_localizations_utils.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';
import 'package:parchment/codecs.dart'; // ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

final themeModeNotifier = ValueNotifier(ThemeUtils().themeMode);
final dynamicThemingNotifier = ValueNotifier(ThemeUtils().useDynamicTheming);
final blackThemingNotifier = ValueNotifier(ThemeUtils().useBlackTheming);

final fleatherFieldHasFocusNotifier = ValueNotifier(false);

final navigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root navigator key');
final drawerKey = GlobalKey<ScaffoldState>(debugLabel: 'Drawer key');

final localizations = AppLocalizations.of(navigatorKey.currentContext!)!;
final hardcodedLocalizations = HardcodedLocalizationsUtils();

const uuid = Uuid();

const parchmentMarkdownCodec = ParchmentMarkdownCodec();
