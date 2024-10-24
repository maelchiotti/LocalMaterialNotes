import 'package:isar/isar.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:path_provider/path_provider.dart';

/// Abstract service for the database.
class DatabaseService {
  static final DatabaseService _singleton = DatabaseService._internal();

  /// Default constructor.
  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal();

  /// Isar database instance.
  late Isar database;

  /// Ensures the service is initialized.
  Future<void> ensureInitialized() async {
    final databaseName = 'materialnotes';
    final databaseDirectory = (await getApplicationDocumentsDirectory()).path;

    database = await Isar.open(
      [NoteSchema, LabelSchema],
      name: databaseName,
      directory: databaseDirectory,
    );
  }
}
