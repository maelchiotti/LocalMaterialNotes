import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/theme_utils.dart';

/// Notifier for the app theme mode.
final themeModeNotifier = ValueNotifier(ThemeUtils().themeMode);

/// Notifier for whether to use dynamic theming.
final dynamicThemingNotifier = ValueNotifier(ThemeUtils().useDynamicTheming);

/// Notifier for whether to use black theming.
final blackThemingNotifier = ValueNotifier(ThemeUtils().useBlackTheming);

/// Notifier for the text scaling.
final textScalingNotifier = ValueNotifier(PreferenceKey.textScaling.getPreferenceOrDefault<double>());

/// Notifier for whether the selection mode is active.
final isSelectionModeNotifier = ValueNotifier(false);

/// Notifier for the notes layout.
final layoutNotifier = ValueNotifier(Layout.fromPreference());

/// Notifier for whether to show the notes titles.
final showTitlesOnlyNotifier = ValueNotifier(PreferenceKey.showTitlesOnly.getPreferenceOrDefault<bool>());

/// Notifier for whether to show the notes tiles background.
final showTilesBackgroundNotifier = ValueNotifier(PreferenceKey.showTilesBackground.getPreferenceOrDefault<bool>());

/// Notifier for whether to show the separators between the notes tiles.
final showSeparatorsNotifier = ValueNotifier(PreferenceKey.showSeparators.getPreferenceOrDefault<bool>());

/// Notifier for the actions on the notes tiles swipe.
final ValueNotifier<({SwipeAction right, SwipeAction left})> swipeActionsNotifier = ValueNotifier((
  right: SwipeAction.rightFromPreference(),
  left: SwipeAction.leftFromPreference(),
));

/// Notifier for the currently displayed note.
final currentNoteNotifier = ValueNotifier<Note?>(null);

/// Notifier for the fleather editor controller of the currently displayed note.
final fleatherControllerNotifier = ValueNotifier<FleatherController?>(null);

/// Notifier for whether the undo action can be used on the currently displayed note.
final fleatherControllerCanUndoNotifier = ValueNotifier(false);

/// Notifier for whether the redo action can be used on the currently displayed note.
final fleatherControllerCanRedoNotifier = ValueNotifier(false);

/// Notifier for whether the fleather editor has focus.
final fleatherFieldHasFocusNotifier = ValueNotifier(false);

/// Notifier for whether the fleather editor is in edit mode.
final isFleatherEditorEditMode = ValueNotifier(!PreferenceKey.openEditorReadingMode.getPreferenceOrDefault<bool>());
