import 'package:isar_community/isar.dart';

import '../../common/constants/constants.dart';
import '../../common/preferences/preference_key.dart';
import '../../models/deprecated/note.dart';
import '../../models/label/label.dart';
import '../../models/note/note.dart';
import '../database_service.dart';

/// Database migration service.
class MigrationService {
  final _databaseService = DatabaseService();

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
    final database = _databaseService.database;

    // Get the notes and their labels
    final notes = await database.notes.where().findAll();
    final labels = notes.map((note) => note.labels.toList()).toList();

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

    // Replace the notes by the migrated ones with their labels, all at once so that a failure loses nothing
    await database.writeTxn(() async {
      await database.notes.clear();
      await database.richTextNotes.putAll(migratedNotes);
      await _putLabels(migratedNotes, labels);
    });

    // Update the database version
    await PreferenceKey.databaseVersion.set(2);

    logger.i('Migrated the database from version 1 to version 2');
  }

  /// Migrates the database to version 3.
  ///
  /// Sets the new `id`, `archived` and `deletedTime` fields of each rich text note.
  Future<void> _migrateToV3() async {
    final database = _databaseService.database;

    // Get the rich text notes, their labels and their old IDs
    final richTextNotes = await database.richTextNotes.where().findAll();
    final labels = richTextNotes.map((note) => note.labels.toList()).toList();
    final oldIds = richTextNotes.map((note) => note.isarId).toList();

    // Migrate the notes
    final migratedNotes = richTextNotes
        .map(
          (richTextNote) => richTextNote
            ..id = uuid.v4()
            ..archived = false
            ..deletedTime = richTextNote.deleted ? DateTime.timestamp() : null,
        )
        .toList();

    // Replace the notes with the old IDs by the migrated ones with their labels, which are linked to the IDs,
    // all at once so that a failure loses nothing
    await database.writeTxn(() async {
      await database.richTextNotes.deleteAll(oldIds);
      await database.richTextNotes.putAll(migratedNotes);
      await _putLabels(migratedNotes, labels);
    });

    // Update the database version
    await PreferenceKey.databaseVersion.set(3);

    logger.i('Migrated the database from version 2 to version 3');
  }

  /// Links each of the [notes] to its [labels], inside a write transaction.
  Future<void> _putLabels(List<RichTextNote> notes, List<List<Label>> labels) async {
    for (var i = 0; i < notes.length; i++) {
      await notes[i].labels.reset();
      notes[i].labels.addAll(labels[i]);
      await notes[i].labels.save();
    }
  }
}
