import 'package:collection/collection.dart';
import '../../common/constants/constants.dart';
import '../../common/extensions/list_extension.dart';
import '../../models/label/label.dart';
import '../../models/note/note.dart';
import '../bin/bin_provider.dart';
import '../../services/notes/notes_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_provider.g.dart';

/// Provider for the notes.
@Riverpod(keepAlive: true)
class Notes extends _$Notes {
  final _notesService = NotesService();

  @override
  FutureOr<List<Note>> build() => get();

  /// Returns the list of not deleted notes.
  Future<List<Note>> get() async {
    List<Note> notes = [];

    try {
      notes = await _notesService.getAllNotDeleted();
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);
    }

    final sortedNotes = notes.sorted();
    for (final sortedNote in sortedNotes) {
      sortedNote.labels.sorted();
    }

    state = AsyncData(sortedNotes);

    return notes.sorted();
  }

  /// Returns the list of not deleted notes.
  Future<List<Note>> filter(Label label) async {
    List<Note> notes = [];

    try {
      notes = await _notesService.filterByLabel(label);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);
    }

    state = AsyncData(notes.sorted());

    return notes.sorted();
  }

  /// Sorts the not deleted notes.
  void sort() {
    final sortedNotes = (state.value ?? []).sorted();

    state = AsyncData(sortedNotes);
  }

  /// Saves the [editedNote] to the database.
  Future<bool> edit(Note editedNote) async {
    editedNote.editedTime = DateTime.now();

    try {
      if (editedNote.isEmpty) {
        await _notesService.delete(editedNote);
      } else {
        await _notesService.put(editedNote);
      }
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? []);
    if (!editedNote.deleted && !editedNote.isEmpty) {
      notes.addOrUpdate(editedNote);
    } else {
      notes.remove(editedNote);
    }

    state = AsyncData(notes.sorted());

    return true;
  }

  /// Saves the [note] with the new [selectedLabels] to the database.
  Future<bool> editLabels(Note note, Iterable<Label> selectedLabels) async {
    note.editedTime = DateTime.now();

    try {
      await _notesService.putLabels(note, selectedLabels);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? []);
    if (!note.deleted && !note.isEmpty) {
      notes.addOrUpdate(note);
    } else {
      notes.remove(note);
    }

    state = AsyncData(notes.sorted());

    return true;
  }

  /// Toggles the pin status of the [noteToToggle] in the database.
  Future<bool> togglePin(Note noteToToggle) async {
    noteToToggle.pinned = !noteToToggle.pinned;

    try {
      await _notesService.put(noteToToggle);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? [])
      ..remove(noteToToggle)
      ..add(noteToToggle);

    state = AsyncData(notes.sorted());

    return true;
  }

  /// Toggles the pin status of the [notesToToggle] in the database.
  Future<bool> togglePinAll(List<Note> notesToToggle) async {
    for (final note in notesToToggle) {
      note.pinned = !note.pinned;
    }

    try {
      await _notesService.putAll(notesToToggle);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? [])
      ..removeWhere((note) => notesToToggle.contains(note))
      ..addAll(notesToToggle);

    state = AsyncData(notes.sorted());

    return true;
  }

  /// Sets the [note] as deleted in the database.
  Future<bool> delete(Note note) async {
    note.pinned = false;
    note.deleted = true;

    final succeeded = await edit(note);

    ref.read(binProvider.notifier).get();

    return succeeded;
  }

  /// Sets the [notes] as deleted in the database.
  Future<bool> deleteAll(List<Note> notesToDelete) async {
    for (final note in notesToDelete) {
      note.pinned = false;
      note.deleted = true;
    }

    try {
      await _notesService.putAll(notesToDelete);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? [])..removeWhere((note) => notesToDelete.contains(note));

    state = AsyncData(notes);

    ref.read(binProvider.notifier).get();

    return true;
  }

  /// Selects the [noteToSelect].
  void select(Note noteToSelect) {
    state = AsyncData([
      for (final Note note in state.value ?? []) note == noteToSelect ? (noteToSelect..selected = true) : note,
    ]);
  }

  /// Unselects the [noteToSelect].
  void unselect(Note noteToUnselect) {
    state = AsyncData([
      for (final Note note in state.value ?? []) note == noteToUnselect ? (noteToUnselect..selected = false) : note,
    ]);
  }

  /// Selects all the not deleted notes.
  void selectAll() {
    state = AsyncData([
      ...?state.value
        ?..forEach((note) {
          note.selected = true;
        }),
    ]);
  }

  /// Unselects all the not deleted notes.
  void unselectAll() {
    state = AsyncData([
      ...?state.value
        ?..forEach((note) {
          note.selected = false;
        }),
    ]);
  }
}
