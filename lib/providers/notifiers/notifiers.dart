import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../../common/preferences/preference_key.dart';
import '../../models/label/label.dart';
import 'current_note_notifier.dart';
import 'lock_notifier.dart';

/// Notifier for whether the application is locked.
final lockAppNotifier = LockNotifier(PreferenceKey.lockApp.preferenceOrDefault);

/// Notifier for whether the current note is locked.
final lockNoteNotifier = LockNotifier(false);

/// Notifier for the value of the current label filter on the notes.
Label? currentLabelFilter;

/// Notifier for whether the notes selection mode is active.
final isNotesSelectionModeNotifier = ValueNotifier(false);

/// Notifier for whether the labels selection mode is active.
final isLabelsSelectionModeNotifier = ValueNotifier(false);

/// Notifier for the currently displayed note.
final currentNoteNotifier = CurrentNoteNotifier();

/// Notifier for the fleather editor controller of the currently displayed note.
final fleatherControllerNotifier = ValueNotifier<FleatherController?>(null);

/// Notifier for whether the undo action can be used on the currently displayed note.
final fleatherControllerCanUndoNotifier = ValueNotifier(false);

/// Notifier for whether the redo action can be used on the currently displayed note.
final fleatherControllerCanRedoNotifier = ValueNotifier(false);

/// Notifier for whether the editor has focus.
final editorHasFocusNotifier = ValueNotifier(false);

/// Notifier for whether the editor is in edit mode.
final isEditModeNotifier = ValueNotifier(!PreferenceKey.openEditorReadingMode.preferenceOrDefault);

/// Notifier for whether the labels filters are shown.
final labelsFiltersNotifier = ValueNotifier(false);
