import 'dart:developer';

import 'package:collection/collection.dart';
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
    List<Note> notes = [];

    try {
      notes = await databaseUtils.getAll(deleted: false);
    } on Exception catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
    }

    state = AsyncData(notes);

    return notes;
  }

  void sort() {
    final sortedNotes = (state.value ?? []).sorted((note, otherNote) => note.compareTo(otherNote));

    state = AsyncData(sortedNotes);
  }

  Future<bool> edit(Note editedNote) async {
    editedNote.editedTime = DateTime.now();

    try {
      if (editedNote.isEmpty) {
        await databaseUtils.delete(editedNote);
      } else {
        await databaseUtils.put(editedNote);
      }
    } on Exception catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not edited
    final newNotes = (state.value ?? []).where((note) => note != editedNote).toList();

    // Add the edited note if it was not deleted and it is not empty
    if (!editedNote.deleted && !editedNote.isEmpty) {
      newNotes.add(editedNote);
    }

    // Sort all the notes
    final sortedNotes = newNotes.sorted((note, otherNote) => note.compareTo(otherNote));

    state = AsyncData(sortedNotes);

    return true;
  }

  Future<bool> togglePin(Note note) async {
    note.pinned = !note.pinned;

    return await edit(note);
  }

  Future<bool> togglePinAll(List<Note> notes) async {
    for (final note in notes) {
      note.pinned = !note.pinned;
    }

    try {
      await databaseUtils.putAll(notes);
    } on Exception catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes for which the pin was not toggled
    final newNotes = (state.value ?? []).where((note) => !notes.contains(note)).toList();

    // Add all the notes for which the pin was toggled
    newNotes.addAll(notes);

    // Sort all the notes
    final sortedNotes = newNotes.sorted((note, otherNote) => note.compareTo(otherNote));

    state = AsyncData(sortedNotes);

    return true;
  }

  Future<bool> delete(Note note) async {
    note.pinned = false;
    note.deleted = true;

    return await edit(note);
  }

  Future<bool> deleteAll(List<Note> notes) async {
    for (final note in notes) {
      note.pinned = false;
      note.deleted = true;
    }

    try {
      await databaseUtils.putAll(notes);
    } on Exception catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not deleted
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
