import 'package:flutter_mimir/flutter_mimir.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/deprecated/note.dart';
import '../models/label/label.dart';
import '../models/note/note.dart';
import 'bin/bin_service.dart';
import 'labels/labels_service.dart';
import 'migration/migration_service.dart';
import 'notes/notes_index_service.dart';
import 'notes/notes_service.dart';

/// Abstract service for the database.
///
/// This class is a singleton.
class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();

  /// Default constructor.
  factory DatabaseService() => _singleton;

  DatabaseService._internal();

  /// Isar database instance.
  late final Isar database;

  /// Mimir index instance.
  late final MimirInstance mimir;

  /// Ensures the service is initialized.
  Future<void> ensureInitialized() async {
    final databaseName = 'materialnotes';
    final databaseDirectory = (await getApplicationDocumentsDirectory()).path;

    // Initialize the database
    database = await Isar.open(
      [NoteSchema, PlainTextNoteSchema, RichTextNoteSchema, MarkdownNoteSchema, ChecklistNoteSchema, LabelSchema],
      name: databaseName,
      directory: databaseDirectory,
    );

    // Initialize mimir
    mimir = await Mimir.defaultInstance;

    // Initialize the indexes service
    await NotesIndexService().ensureInitialized();

    // Initialize the models services
    await LabelsService().ensureInitialized();
    await NotesService().ensureInitialized();

    // Perform migrations if needed
    await MigrationService().migrateIfNeeded();

    // Remove old notes from the bin if needed
    await BinService().removeNotesFromBinIfNeeded();
  }
}
