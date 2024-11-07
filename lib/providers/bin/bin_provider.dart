import 'package:collection/collection.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/notes/notes/notes_provider.dart';
import 'package:localmaterialnotes/services/notes/notes_service.dart';
import 'package:localmaterialnotes/utils/logs_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bin_provider.g.dart';

/// Provider for the deleted notes.
@Riverpod(keepAlive: true)
class Bin extends _$Bin {
  final _notesService = NotesService();

  @override
  FutureOr<List<Note>> build() {
    return get();
  }

  /// Returns the list of deleted notes.
  Future<List<Note>> get() async {
    List<Note> notes = [];

    try {
      notes = await _notesService.getAll(deleted: true);
    } catch (exception, stackTrace) {
      LogsUtils().handleException(exception, stackTrace);
    }

    state = AsyncData(notes.sorted());

    return notes.sorted();
  }

  /// Sorts the deleted notes.
  void sort() {
    final sortedNotes = (state.value ?? []).sorted();

    state = AsyncData(sortedNotes);
  }

  /// Removes all the deleted notes from the database.
  Future<bool> empty() async {
    try {
      await _notesService.emptyBin();
    } catch (exception, stackTrace) {
      LogsUtils().handleException(exception, stackTrace);
      return false;
    }

    state = const AsyncData([]);

    return true;
  }

  /// Removes the [noteToPermanentlyDelete] from the database.
  Future<bool> permanentlyDelete(Note noteToPermanentlyDelete) async {
    try {
      await _notesService.delete(noteToPermanentlyDelete);
    } catch (exception, stackTrace) {
      LogsUtils().handleException(exception, stackTrace);
      return false;
    }

    state = AsyncData(
      (state.value ?? [])..remove(noteToPermanentlyDelete),
    );

    return true;
  }

  /// Removes the [notesToPermanentlyDelete] from the database.
  Future<bool> permanentlyDeleteAll(List<Note> notesToPermanentlyDelete) async {
    for (final note in notesToPermanentlyDelete) {
      note.deleted = false;
    }

    try {
      await _notesService.deleteAll(notesToPermanentlyDelete);
    } catch (exception, stackTrace) {
      LogsUtils().handleException(exception, stackTrace);
      return false;
    }

    state = AsyncData(
      (state.value ?? [])
        ..removeWhere(
          (note) => notesToPermanentlyDelete.contains(note),
        ),
    );

    return true;
  }

  /// Sets the [noteToRestore] as not deleted in the database.
  Future<bool> restore(Note noteToRestore) async {
    noteToRestore.deleted = false;

    try {
      await _notesService.put(noteToRestore);
    } catch (exception, stackTrace) {
      LogsUtils().handleException(exception, stackTrace);
      return false;
    }

    state = AsyncData(
      (state.value ?? [])..remove(noteToRestore),
    );

    ref.read(notesProvider.notifier).get();

    return true;
  }

  /// Sets the [notesToRestore] as not deleted in the database.
  Future<bool> restoreAll(List<Note> notesToRestore) async {
    for (final note in notesToRestore) {
      note.deleted = false;
    }

    try {
      await _notesService.putAll(notesToRestore);
    } catch (exception, stackTrace) {
      LogsUtils().handleException(exception, stackTrace);
      return false;
    }

    state = AsyncData(
      (state.value ?? [])
        ..removeWhere(
          (note) => notesToRestore.contains(note),
        ),
    );

    ref.read(notesProvider.notifier).get();

    return true;
  }

  /// Selects the [noteToSelect].
  void select(Note noteToSelect) {
    state = AsyncData([
      for (final Note note in state.value ?? []) note == noteToSelect ? (noteToSelect..selected = true) : note,
    ]);
  }

  /// Unselects the [noteToUnselect].
  void unselect(Note noteToUnselect) {
    state = AsyncData([
      for (final Note note in state.value ?? []) note == noteToUnselect ? (noteToUnselect..selected = false) : note,
    ]);
  }

  /// Selects all the deleted notes.
  void selectAll() {
    state = AsyncData([
      ...?state.value
        ?..forEach((note) {
          note.selected = true;
        }),
    ]);
  }

  /// Unselects all the deleted notes.
  void unselectAll() {
    state = AsyncData([
      ...?state.value
        ?..forEach((note) {
          note.selected = false;
        }),
    ]);
  }
}
