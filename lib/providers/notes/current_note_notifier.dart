import 'package:flutter/material.dart';
import 'package:localmaterialnotes/models/note/note.dart';

class CurrentNoteNotifier extends ValueNotifier<Note?> {
  CurrentNoteNotifier() : super(null);

  void forceNotify() {
    notifyListeners();
  }
}
