import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bin_provider.g.dart';

@riverpod
class Bin extends _$Bin {
  @override
  FutureOr<List<Note>> build() {
    return get();
  }

  /// Returns the list of deleted notes.
  Future<List<Note>> get() async {
    List<Note> notes = [];

    try {
      notes = await DatabaseUtils().getAll(deleted: true);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
    }

    state = AsyncData(notes);

    return notes;
  }

  /// Sorts the deleted notes.
  Future<void> sort() async {
    final sortedNotes = (state.value ?? []).sorted((note, otherNote) => note.compareTo(otherNote));

    state = AsyncData(sortedNotes);
  }

  /// Removes all the deleted notes from the database.
  Future<bool> empty() async {
    try {
      await DatabaseUtils().emptyBin();
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    state = const AsyncData([]);

    return true;
  }

  /// Removes the [permanentlyDeletedNote] from the database.
  Future<bool> permanentlyDelete(Note permanentlyDeletedNote) async {
    try {
      await DatabaseUtils().delete(permanentlyDeletedNote);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not permanently deleted
    final newNotes = (state.value ?? []).where((note) => note != permanentlyDeletedNote).toList();

    state = AsyncData(newNotes);

    return true;
  }

  /// Removes the [permanentlyDeletedNotes] from the database.
  Future<bool> permanentlyDeleteAll(List<Note> notes) async {
    for (final note in notes) {
      note.deleted = false;
    }

    try {
      await DatabaseUtils().deleteAll(notes);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not permanently deleted
    final newNotes = (state.value ?? []).where((note) => !notes.contains(note)).toList();

    state = AsyncData(newNotes);

    return true;
  }

  /// Sets the [restoredNote] as not deleted in the database.
  Future<bool> restore(Note restoredNote) async {
    restoredNote.deleted = false;

    try {
      await DatabaseUtils().put(restoredNote);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not restored
    final newNotes = (state.value ?? []).where((note) => note != restoredNote).toList();

    state = AsyncData(newNotes);

    return true;
  }

  /// Sets the [restoredNotes] as not deleted in the database.
  Future<bool> restoreAll(List<Note> notes) async {
    for (final note in notes) {
      note.deleted = false;
    }

    try {
      await DatabaseUtils().putAll(notes);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not restored
    final newNotes = (state.value ?? []).where((note) => !notes.contains(note)).toList();

    state = AsyncData(newNotes);

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
