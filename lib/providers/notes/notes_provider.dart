import 'dart:developer';

import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/base_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_provider.g.dart';

@riverpod
class Notes extends _$Notes with BaseProvider {
  @override
  FutureOr<List<Note>> build() {
    return get();
  }

  Future<List<Note>> get() async {
    state = const AsyncLoading();

    List<Note> notes = [];

    try {
      notes = await databaseManager.getAll(deleted: false);
    } on Exception catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
    }

    state = AsyncData(notes);

    return notes;
  }

  Future<void> sort() async {
    await get();
  }

  Future<bool> edit(Note editedNote) async {
    state = const AsyncLoading();

    editedNote.editedTime = DateTime.now();

    try {
      if (editedNote.isEmpty) {
        await databaseManager.delete(editedNote.isarId);
      } else {
        await databaseManager.edit(editedNote);
      }
    } on Exception catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    final newNotes = (state.value ?? []).where((note) => note.id != editedNote.id).toList();
    if (!editedNote.deleted) {
      newNotes.add(editedNote);
    }
    state = AsyncData(newNotes);

    return true;
  }

  Future<bool> togglePin(Note note) async {
    note.pinned = !note.pinned;

    final edited = await edit(note);
    await get();

    return edited;
  }

  Future<bool> delete(Note note) async {
    note.pinned = false;
    note.deleted = true;

    return await edit(note);
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
