import 'package:flutter/material.dart';
import 'package:localmaterialnotes/models/note/note.dart';

/// Current note notifier.
class CurrentNoteNotifier extends ValueNotifier<Note?> {
  /// Custom notifier for the currently opened note.
  CurrentNoteNotifier() : super(null);

  /// Forcefully notify all the listeners.
  void forceNotify() {
    notifyListeners();
  }
}
