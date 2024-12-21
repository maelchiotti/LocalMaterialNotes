import 'package:flutter/material.dart';
import '../../models/note/note.dart';

/// Current note notifier.
class CurrentNoteNotifier extends ValueNotifier<Note?> {
  /// Custom notifier for the currently opened note.
  CurrentNoteNotifier() : super(null);

  /// Forcefully notify all the listeners.
  void forceNotify() {
    notifyListeners();
  }
}
