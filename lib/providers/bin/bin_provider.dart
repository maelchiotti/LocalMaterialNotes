import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/base_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bin_provider.g.dart';

@riverpod
class Bin extends _$Bin with BaseProvider {
  @override
  FutureOr<List<Note>> build() {
    return get();
  }

  Future<List<Note>> get() async {
    List<Note> notes = [];

    try {
      notes = await databaseUtils.getAll(deleted: true);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
    }

    state = AsyncData(notes);

    return notes;
  }

  Future<void> sort() async {
    final sortedNotes = (state.value ?? []).sorted((note, otherNote) => note.compareTo(otherNote));

    state = AsyncData(sortedNotes);
  }

  Future<bool> empty() async {
    try {
      await databaseUtils.emptyBin();
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    state = const AsyncData([]);

    return true;
  }

  Future<bool> permanentlyDelete(Note permanentlyDeletedNote) async {
    try {
      await databaseUtils.delete(permanentlyDeletedNote);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not permanently deleted
    final newNotes = (state.value ?? []).where((note) => note != permanentlyDeletedNote).toList();

    state = AsyncData(newNotes);

    return true;
  }

  Future<bool> permanentlyDeleteAll(List<Note> notes) async {
    for (final note in notes) {
      note.deleted = false;
    }

    try {
      await databaseUtils.deleteAll(notes);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not permanently deleted
    final newNotes = (state.value ?? []).where((note) => !notes.contains(note)).toList();

    state = AsyncData(newNotes);

    return true;
  }

  Future<bool> restore(Note restoredNote) async {
    restoredNote.deleted = false;

    try {
      await databaseUtils.put(restoredNote);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not restored
    final newNotes = (state.value ?? []).where((note) => note != restoredNote).toList();

    state = AsyncData(newNotes);

    return true;
  }

  Future<bool> restoreAll(List<Note> notes) async {
    for (final note in notes) {
      note.deleted = false;
    }

    try {
      await databaseUtils.putAll(notes);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not restored
    final newNotes = (state.value ?? []).where((note) => !notes.contains(note)).toList();

    state = AsyncData(newNotes);

    return true;
  }

  void select(Note noteToSelect) {
    state = AsyncData([
      for (final Note note in state.value ?? []) note == noteToSelect ? (noteToSelect..selected = true) : note,
    ]);
  }

  void unselect(Note noteToUnselect) {
    state = AsyncData([
      for (final Note note in state.value ?? []) note == noteToUnselect ? (noteToUnselect..selected = false) : note,
    ]);
  }

  void selectAll() {
    state = AsyncData([
      ...?state.value
        ?..forEach((note) {
          note.selected = true;
        }),
    ]);
  }

  void unselectAll() {
    state = AsyncData([
      ...?state.value
        ?..forEach((note) {
          note.selected = false;
        }),
    ]);
  }
}
