import 'package:isar/isar.dart';

/// Abstract service for the database.
abstract class DatabaseService {
  /// Name of the database.
  final databaseName = 'materialnotes';

  /// Directory where the database is stored.
  abstract String databaseDirectory;

  /// Isar database instance.
  abstract Isar database;

  /// Ensures the service is initialized.
  Future<void> ensureInitialized();
}
