import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import '../../common/preferences/preference_key.dart';
import '../../models/label/label.dart';
import 'current_note_notifier.dart';
import 'lock_notifier.dart';

/// Lock notifier for the application.
final lockAppNotifier = LockNotifier(PreferenceKey.lockApp.preferenceOrDefault);

/// Lock notifier for the note.
final lockNoteNotifier = LockNotifier(false);

/// Value of the current label filter on the notes.
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

/// Notifier for whether the fleather editor has focus.
final editorHasFocusNotifier = ValueNotifier(false);

/// Notifier for whether the fleather editor is in edit mode.
final isEditorInEditModeNotifier = ValueNotifier(!PreferenceKey.openEditorReadingMode.preferenceOrDefault);
