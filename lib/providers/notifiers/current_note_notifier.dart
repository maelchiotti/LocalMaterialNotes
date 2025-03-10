import 'package:flutter/material.dart';

import '../../models/note/note.dart';

/// Current note notifier.
class CurrentNoteNotifier extends ValueNotifier<Note?> {
  /// Custom notifier for the currently opened note.
  CurrentNoteNotifier() : super(null);

  /// The value of the current note.
  Note? _value;

  /// Returns the current note.
  @override
  Note? get value => _value;

  /// Sets the current note to [newNote].
  @override
  set value(Note? newNote) {
    if (newNote == null) {
      return;
    }

    if (_value == newNote && _value?.labels == newNote.labels) {
      return;
    }

    _value = newNote;
    notifyListeners();
  }
}
