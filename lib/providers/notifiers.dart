import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/preferences/enums/layout.dart';
import 'package:localmaterialnotes/utils/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';

final themeModeNotifier = ValueNotifier(ThemeUtils().themeMode);
final dynamicThemingNotifier = ValueNotifier(ThemeUtils().useDynamicTheming);
final blackThemingNotifier = ValueNotifier(ThemeUtils().useBlackTheming);

final isSelectionModeNotifier = ValueNotifier(false);

final layoutNotifier = ValueNotifier(Layout.fromPreference());
final showTilesBackgroundNotifier = ValueNotifier(PreferenceKey.showTilesBackground.getPreferenceOrDefault<bool>());
final showSeparatorsNotifier = ValueNotifier(PreferenceKey.showSeparators.getPreferenceOrDefault<bool>());

final swipeActionsNotifier = ValueNotifier(
  (SwipeAction.rightFromPreference(), SwipeAction.leftFromPreference()),
);

final currentNoteNotifier = ValueNotifier<Note?>(null);

final fleatherControllerNotifier = ValueNotifier<FleatherController?>(null);
final fleatherControllerCanUndoNotifier = ValueNotifier(false);
final fleatherControllerCanRedoNotifier = ValueNotifier(false);
final fleatherFieldHasFocusNotifier = ValueNotifier(false);
