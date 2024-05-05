import 'dart:developer';

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
    state = const AsyncLoading();

    List<Note> notes = [];

    try {
      notes = await databaseManager.getAll(deleted: true);
    } on Exception catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
    }

    state = AsyncData(notes);

    return notes;
  }

  Future<void> sort() async {
    await get();
  }

  Future<bool> empty() async {
    try {
      await databaseManager.deleteAll();
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    await get();

    return true;
  }

  Future<bool> permanentlyDelete(Note note) async {
    try {
      await databaseManager.delete(note.isarId);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    return true;
  }

  Future<bool> restore(Note noteToRestore) async {
    state = const AsyncLoading();

    noteToRestore.deleted = false;

    try {
      await databaseManager.edit(noteToRestore);
    } on Exception catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

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
