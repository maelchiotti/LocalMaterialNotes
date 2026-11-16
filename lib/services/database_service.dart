import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/deprecated/note.dart';
import '../models/label/label.dart';
import '../models/note/note.dart';
import 'bin/bin_service.dart';
import 'labels/labels_service.dart';
import 'migration/migration_service.dart';
import 'notes/notes_service.dart';

/// Abstract service for the database.
///
/// This class is a singleton.
class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();

  /// Default constructor.
  factory DatabaseService() => _singleton;

  DatabaseService._internal();

  /// The schemas of the collections of the database.
  static const schemas = [
    NoteSchema,
    PlainTextNoteSchema,
    RichTextNoteSchema,
    MarkdownNoteSchema,
    ChecklistNoteSchema,
    LabelSchema,
  ];

  /// The name of the database.
  static const databaseName = 'materialnotes';

  /// Isar database instance.
  late final Isar database;

  /// The directory of the database.
  late final String databaseDirectory;

  /// Ensures the service is initialized.
  Future<void> ensureInitialized() async {
    databaseDirectory = (await getApplicationDocumentsDirectory()).path;

    // Initialize the database
    database = await Isar.open(schemas, name: databaseName, directory: databaseDirectory);

    // Initialize the models services
    await LabelsService().ensureInitialized();
    await NotesService().ensureInitialized();

    // Perform migrations if needed
    await MigrationService().migrateIfNeeded();

    // Remove old notes from the bin if needed
    await BinService().removeNotesFromBinIfNeeded();
  }
}
