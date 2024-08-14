import 'package:isar/isar.dart';

/// Abstract service for the database.
abstract class DatabaseService {
  /// Name of the database.
  final databaseName = 'materialnotes';

  /// Directory where the database is stored.
  ///
  /// Needs to be set by the implementing class.
  late String databaseDirectory;

  /// Isar database instance.
  ///
  /// Needs to be set by the implementing class.
  late Isar database;

  /// Ensures the service is initialized.
  Future<void> ensureInitialized();
}
