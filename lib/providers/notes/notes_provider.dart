import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/services/notes/notes_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_provider.g.dart';

/// Provider for the notes.
@riverpod
class Notes extends _$Notes {
  final _notesService = NotesService();

  @override
  FutureOr<List<Note>> build() {
    return get();
  }

  /// Returns the list of not deleted notes.
  Future<List<Note>> get() async {
    List<Note> notes = [];

    try {
      notes = await _notesService.getAll();
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
    }

    state = AsyncData(notes);

    return notes;
  }

  /// Sorts the not deleted notes.
  void sort() {
    final sortedNotes = (state.value ?? []).sorted((note, otherNote) => note.compareTo(otherNote));

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

  /// Toggles the pin status of the [note] in the database.
  Future<bool> togglePin(Note note) async {
    note.pinned = !note.pinned;

    return await edit(note);
  }

  /// Toggles the pin status of the [notes] in the database.
  Future<bool> togglePinAll(List<Note> notes) async {
    for (final note in notes) {
      note.pinned = !note.pinned;
    }

    try {
      await _notesService.putAll(notes);
    } catch (exception, stackTrace) {
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

  /// Sets the [note] as deleted in the database.
  Future<bool> delete(Note note) async {
    note.pinned = false;
    note.deleted = true;

    return await edit(note);
  }

  /// Sets the [notes] as deleted in the database.
  Future<bool> deleteAll(List<Note> notes) async {
    for (final note in notes) {
      note.pinned = false;
      note.deleted = true;
    }

    try {
      await _notesService.putAll(notes);
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);
      return false;
    }

    // Keep all the notes that were not deleted
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
