import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/preferences/layout.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';

final themeModeNotifier = ValueNotifier(ThemeUtils().themeMode);
final dynamicThemingNotifier = ValueNotifier(ThemeUtils().useDynamicTheming);
final blackThemingNotifier = ValueNotifier(ThemeUtils().useBlackTheming);

final isSelectionModeNotifier = ValueNotifier(false);
final layoutNotifier = ValueNotifier(Layout.fromPreference());

final fleatherControllerNotifier = ValueNotifier<FleatherController?>(null);
final fleatherControllerCanUndoNotifier = ValueNotifier(false);
final fleatherControllerCanRedoNotifier = ValueNotifier(false);
final fleatherFieldHasFocusNotifier = ValueNotifier(false);
