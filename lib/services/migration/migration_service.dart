import 'package:isar_community/isar.dart';

import '../../common/constants/constants.dart';
import '../../common/preferences/preference_key.dart';
import '../../models/deprecated/note.dart';
import '../../models/note/note.dart';
import '../database_service.dart';
import '../notes/notes_index_service.dart';
import '../notes/notes_service.dart';

/// Database migration service.
class MigrationService {
  final _databaseService = DatabaseService();
  final _indexesService = NotesIndexService();
  final _notesService = NotesService();

  /// Migrates the database to the latest version if needed.
  Future<void> migrateIfNeeded() async {
    final databaseVersion = PreferenceKey.databaseVersion.preferenceOrDefault;

    if (databaseVersion < 2) {
      await _migrateToV2();
    }

    if (databaseVersion < 3) {
      await _migrateToV3();
    }
  }

  /// Migrates the database to version 2.
  ///
  /// Moves all legacy notes from the legacy `notes` collection to the new `richTextNotes` collection
  /// to allow adding different types of notes.
  Future<void> _migrateToV2() async {
    // Get the notes and their labels
    final notes = await _databaseService.database.notes.where().findAll();
    final labels = notes.map((note) => note.labels.toList()).toList();

    // Remove the notes
    await _databaseService.database.notes.clear();

    // Migrate the notes
    final migratedNotes = notes
        .map(
          (oldNote) => RichTextNote(
            archived: false,
            deleted: oldNote.deleted,
            pinned: oldNote.pinned,
            locked: false,
            createdTime: oldNote.createdTime,
            editedTime: oldNote.editedTime,
            title: oldNote.title,
            content: oldNote.content,
          ),
        )
        .toList();

    // Add the migrated notes to the new collection with their labels
    await _notesService.putAll(migratedNotes);
    await _notesService.putAllLabels(migratedNotes, labels);

    // Update the database version
    await PreferenceKey.databaseVersion.set(2);

    logger.i('Migrated the database from version 1 to version 2');
  }

  /// Migrates the database to version 3.
  ///
  /// Sets the new `id`, `archived` and `deletedTime` fields of each rich text note.
  Future<void> _migrateToV3() async {
    // Clear the indexes to ensure their are rebuilt correctly
    await _indexesService.clearIndexes();

    // Get the rich text notes
    final richTextNotes = await _databaseService.database.richTextNotes.where().findAll();

    // Remove the notes with the old IDs
    await _notesService.deleteAll(richTextNotes);

    // Migrate the notes
    final migratedNotes = richTextNotes
        .map(
          (richTextNote) => richTextNote
            ..id = uuid.v4()
            ..archived = false
            ..deletedTime = richTextNote.deleted ? DateTime.timestamp() : null,
        )
        .toList();

    // Put back the migrated notes with the right IDs
    await _notesService.putAll(migratedNotes);

    // Update the database version
    await PreferenceKey.databaseVersion.set(3);

    logger.i('Migrated the database from version 2 to version 3');
  }
}
