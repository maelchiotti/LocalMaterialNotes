import 'package:flutter_mimir/flutter_mimir.dart';
import 'package:isar/isar.dart';
import '../models/label/label.dart';
import '../models/note/note.dart';
import 'labels/labels_service.dart';
import 'notes/notes_service.dart';
import 'package:path_provider/path_provider.dart';

/// Abstract service for the database.
///
/// This class is a singleton.
class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();

  /// Default constructor.
  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal();

  /// Isar database instance.
  late final Isar database;

  /// Mimir index instance.
  late final MimirInstance mimir;

  /// Ensures the service is initialized.
  Future<void> ensureInitialized() async {
    final databaseName = 'materialnotes';
    final databaseDirectory = (await getApplicationDocumentsDirectory()).path;

    database = await Isar.open(
      [NoteSchema, LabelSchema],
      name: databaseName,
      directory: databaseDirectory,
    );

    mimir = await Mimir.defaultInstance;

    // Initialize the models services
    await LabelsService().ensureInitialized();
    await NotesService().ensureInitialized();
  }
}
