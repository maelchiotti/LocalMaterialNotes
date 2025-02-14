import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/constants/constants.dart';
import '../../common/extensions/list_extension.dart';
import '../../models/label/label.dart';
import '../../models/note/note.dart';
import '../../models/note/note_status.dart';
import '../../services/notes/notes_service.dart';

part 'notes_provider.g.dart';

/// Provider for the notes.
@riverpod
class Notes extends _$Notes {
  final _notesService = NotesService();

  @override
  FutureOr<List<Note>> build({required NoteStatus status, Label? label}) => get();

  /// Returns the list of notes depending on their [status].
  Future<List<Note>> get() async {
    List<Note> notes = [];

    try {
      switch (status) {
        case NoteStatus.available:
          notes = label != null
              ? await _notesService.getAllNotDeletedFilteredByLabel(label: label!)
              : await _notesService.getAllNotDeleted();
        case NoteStatus.deleted:
          notes = await _notesService.getAllDeleted();
      }
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);
    }

    final sortedNotes = notes.sorted();

    state = AsyncData(sortedNotes);

    return notes.sorted();
  }

  /// Sorts the notes.
  void sort() {
    final sortedNotes = (state.value ?? []).sorted();

    state = AsyncData(sortedNotes);
  }

  /// Saves the [editedNote] to the database.
  ///
  /// The note can be forcefully put into the database even it it's empty using [forcePut].
  Future<bool> edit(Note editedNote, {bool forcePut = false}) async {
    _checkEditableStatus();

    editedNote.editedTime = DateTime.now();

    try {
      if (editedNote.isEmpty && !forcePut) {
        await _notesService.delete(editedNote);
      } else {
        await _notesService.put(editedNote);
      }
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? []);
    if (!editedNote.deleted && (!editedNote.isEmpty || forcePut)) {
      notes.addOrUpdate(editedNote);
    } else {
      notes.remove(editedNote);
    }

    state = AsyncData(notes.sorted());
    _updateUnlabeledProvider();

    return true;
  }

  /// Saves the [note] with the new [selectedLabels] to the database.
  Future<bool> editLabels(Note note, Iterable<Label> selectedLabels) async {
    _checkEditableStatus();

    try {
      await _notesService.putLabels(note, selectedLabels);

      // If the note is empty and has no labels, then delete it
      if (note.isEmpty && selectedLabels.isEmpty) {
        await _notesService.delete(note);
      }
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? []);

    // If this provider is labeled and the label was removed from the note, then remove it from the state
    if (label != null && !note.labels.contains(label)) {
      notes.remove(note);
    }

    // If the note is empty and has no labels, then remove it from the state
    if (note.isEmpty && selectedLabels.isEmpty) {
      notes.remove(note);
    }

    state = AsyncData(notes.sorted());
    _updateUnlabeledProvider();

    return true;
  }

  /// Saves the [notes] with the added [selectedLabels] to the database.
  Future<bool> addLabels(List<Note> notesWhereToAdd, Iterable<Label> selectedLabels) async {
    _checkEditableStatus();

    try {
      await _notesService.addLabels(notesWhereToAdd, selectedLabels);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? [])
      ..removeWhere((note) => notesWhereToAdd.contains(note))
      ..addAll(notesWhereToAdd);

    state = AsyncData(notes.sorted());
    _updateUnlabeledProvider();

    return true;
  }

  /// Toggles the pin status of the [noteToToggle] in the database.
  Future<bool> togglePin(Note noteToToggle) async {
    _checkEditableStatus();

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
    _updateUnlabeledProvider();

    return true;
  }

  /// Toggles the pin status of the [notesToToggle] in the database.
  Future<bool> togglePinAll(List<Note> notesToToggle) async {
    _checkEditableStatus();

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
    _updateUnlabeledProvider();

    return true;
  }

  /// Sets the [note] as deleted in the database.
  Future<bool> delete(Note note) async {
    _checkEditableStatus();

    note.pinned = false;
    note.deleted = true;

    final succeeded = await edit(note);

    _updateUnlabeledProvider();
    _updateStatusProvider(NoteStatus.deleted);

    return succeeded;
  }

  /// Sets the [notes] as deleted in the database.
  Future<bool> deleteAll(List<Note> notesToDelete) async {
    _checkEditableStatus();

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

    _updateUnlabeledProvider();
    _updateStatusProvider(NoteStatus.deleted);

    return true;
  }

  /// Removes all the deleted notes from the database.
  Future<bool> emptyBin() async {
    _checkDeletedStatus();

    try {
      await _notesService.emptyBin();
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    state = const AsyncData([]);

    return true;
  }

  /// Removes the [noteToPermanentlyDelete] from the database.
  Future<bool> permanentlyDelete(Note noteToPermanentlyDelete) async {
    _checkDeletedStatus();

    try {
      await _notesService.delete(noteToPermanentlyDelete);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    state = AsyncData(
      (state.value ?? [])..remove(noteToPermanentlyDelete),
    );

    return true;
  }

  /// Removes the [notesToPermanentlyDelete] from the database.
  Future<bool> permanentlyDeleteAll(List<Note> notesToPermanentlyDelete) async {
    _checkDeletedStatus();

    for (final note in notesToPermanentlyDelete) {
      note.deleted = false;
    }

    try {
      await _notesService.deleteAll(notesToPermanentlyDelete);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

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
    _checkDeletedStatus();

    noteToRestore.deleted = false;

    try {
      await _notesService.put(noteToRestore);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    state = AsyncData(
      (state.value ?? [])..remove(noteToRestore),
    );

    _updateUnlabeledProvider();
    _updateStatusProvider(NoteStatus.available);

    return true;
  }

  /// Sets the [notesToRestore] as not deleted in the database.
  Future<bool> restoreAll(List<Note> notesToRestore) async {
    _checkDeletedStatus();

    for (final note in notesToRestore) {
      note.deleted = false;
    }

    try {
      await _notesService.putAll(notesToRestore);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    state = AsyncData(
      (state.value ?? [])
        ..removeWhere(
          (note) => notesToRestore.contains(note),
        ),
    );

    _updateUnlabeledProvider();
    _updateStatusProvider(NoteStatus.available);

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

  /// Checks that the current [status] is editable.
  void _checkEditableStatus() {
    assert(
      NoteStatus.editable.contains(status),
      'This method of the notes provider cannot be called when its status is not editable: $status',
    );
  }

  /// Checks that the current [status] is [NoteStatus.deleted].
  void _checkDeletedStatus() {
    assert(
      status == NoteStatus.deleted,
      'This method method of the notes provider cannot be called when its status is not deleted',
    );
  }

  /// Updates the unlabeled notes provider if this provider is a provider filtered by a label.
  void _updateUnlabeledProvider() {
    if (label != null) {
      ref.read(notesProvider(status: status).notifier).get();
    }
  }

  /// Updates the notes provider with the [status].
  void _updateStatusProvider(NoteStatus status) {
    ref.read(notesProvider(status: status).notifier).get();
  }
}
