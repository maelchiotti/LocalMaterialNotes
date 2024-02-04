import 'package:localmaterialnotes/models/note/note.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_note_provider.g.dart';

// ignore_for_file: use_setters_to_change_properties

@Riverpod(keepAlive: true)
class CurrentNote extends _$CurrentNote {
  @override
  Note? build() {
    return null;
  }

  void set(Note note) {
    state = note;
  }

  void reset() {
    state = null;
  }
}
