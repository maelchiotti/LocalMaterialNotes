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

  /// Returns the list of notes depending on the provider's [status] and [label].
  Future<List<Note>> get() async {
    List<Note> notes = [];

    try {
      switch (status) {
        case NoteStatus.available:
          notes = label != null
              ? await _notesService.getAllAvailableFilteredByLabel(label: label!)
              : await _notesService.getAllAvailable();
        case NoteStatus.archived:
          notes = await _notesService.getAllArchived();
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
  Future<bool> edit(Note editedNote) async {
    _checkStatus([NoteStatus.available, NoteStatus.archived]);

    editedNote.editedTime = DateTime.now();

    try {
      await _notesService.put(editedNote);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? []);
    if (editedNote.deleted) {
      notes.remove(editedNote);
    } else {
      notes.addOrUpdate(editedNote);
    }

    state = AsyncData(notes.sorted());
    _updateUnlabeledProvider();

    return true;
  }

  /// Saves the [note] with the new [selectedLabels] to the database.
  Future<bool> editLabels(Note note, Iterable<Label> selectedLabels) async {
    _checkStatus([NoteStatus.available, NoteStatus.archived]);

    try {
      await _notesService.putLabels(note, selectedLabels);
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
    _checkStatus([NoteStatus.available, NoteStatus.archived]);

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

  /// Toggles whether the [notesToToggle] are pinned.
  Future<bool> togglePin(List<Note> notesToToggle) async {
    _checkStatus([NoteStatus.available, NoteStatus.archived]);

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

  /// Toggles whether the [notesToToggle] are locked.
  Future<bool> toggleLock(List<Note> notesToToggle) async {
    _checkStatus([NoteStatus.available, NoteStatus.archived, NoteStatus.deleted]);

    // Ignore empty notes
    notesToToggle.removeWhere((note) => note.isEmpty);

    for (final note in notesToToggle) {
      note.locked = !note.locked;
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

  /// Sets whether the [notesToSet] are archived to [archived] in the database.
  Future<bool> setArchived(List<Note> notesToSet, bool archived) async {
    _checkStatus([NoteStatus.available, NoteStatus.archived]);

    // Ignore empty notes
    notesToSet.removeWhere((note) => note.isEmpty);

    for (final note in notesToSet) {
      note.pinned = false;
      note.deleted = false;
      note.archived = archived;
    }

    try {
      await _notesService.putAll(notesToSet);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? [])..removeWhere((note) => notesToSet.contains(note));

    state = AsyncData(notes);

    _updateUnlabeledProvider();
    _updateStatusProvider(archived ? NoteStatus.archived : NoteStatus.available);

    return true;
  }

  /// Sets whether the [notesToSet] are deleted to [deleted] in the database.
  Future<bool> setDeleted(List<Note> notesToSet, bool deleted) async {
    _checkStatus([NoteStatus.available, NoteStatus.deleted]);

    final wereArchived = notesToSet.first.archived;

    for (final note in notesToSet) {
      note.pinned = false;
      note.archived = false;
      note.deleted = !note.deleted;
      note.deletedTime = deleted ? DateTime.timestamp() : null;
    }

    try {
      await _notesService.putAll(notesToSet);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final notes = (state.value ?? [])..removeWhere((note) => notesToSet.contains(note));

    state = AsyncData(notes);

    _updateUnlabeledProvider();
    if (deleted) {
      _updateStatusProvider(NoteStatus.deleted);
    } else {
      _updateStatusProvider(wereArchived ? NoteStatus.archived : NoteStatus.available);
    }

    return true;
  }

  /// Removes the [notesToPermanentlyDelete] from the database.
  Future<bool> permanentlyDelete(List<Note> notesToPermanentlyDelete) async {
    _checkStatus([NoteStatus.deleted]);

    try {
      await _notesService.deleteAll(notesToPermanentlyDelete);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    state = AsyncData((state.value ?? [])..removeWhere((note) => notesToPermanentlyDelete.contains(note)));

    return true;
  }

  /// Removes all the deleted notes from the database.
  Future<bool> emptyBin() async {
    _checkStatus([NoteStatus.deleted]);

    try {
      await _notesService.emptyBin();
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    state = const AsyncData([]);

    return true;
  }

  /// Removes the empty notes.
  Future<void> removeEmpty() async {
    final emptyNotes = state.value?.where((note) => note.isEmpty).toList() ?? [];

    try {
      await _notesService.deleteAll(emptyNotes);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);
    }

    state = AsyncData((state.value ?? [])..removeWhere((note) => emptyNotes.contains(note)));
  }

  /// Toggles whether the [noteToToggle] is selected.
  void toggleSelect(Note noteToToggle) {
    state = AsyncData([
      for (final Note note in state.value ?? [])
        note == noteToToggle ? (noteToToggle..selected = !noteToToggle.selected) : note,
    ]);
  }

  /// Sets whether all the notes are selected to [selected].
  void setSelectAll(bool selected) {
    state = AsyncData([
      ...?state.value?..forEach((note) {
        note.selected = selected;
      }),
    ]);
  }

  /// Checks that the current [status] is one of [statuses].
  void _checkStatus(List<NoteStatus> statuses) {
    assert(
      statuses.contains(status),
      'This method of the notes provider cannot be called when its status is not editable: $status',
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
