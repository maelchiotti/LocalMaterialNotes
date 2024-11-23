import 'package:isar/isar.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/pages/labels/enums/labels_filter.dart';
import 'package:localmaterialnotes/services/database_service.dart';

/// Service for the labels database.
///
/// This class is a singleton.
class LabelsService {
  static final LabelsService _singleton = LabelsService._internal();

  /// Default constructor.
  factory LabelsService() {
    return _singleton;
  }

  LabelsService._internal();

  final _database = DatabaseService().database;
  final _labels = DatabaseService().database.labels;

  /// Returns all the labels.
  Future<List<Label>> getAll() async {
    return _labels.where().findAll();
  }

  /// Returns all the labels.
  Future<List<Label>> getAllVisible() async {
    return _labels.filter().visibleEqualTo(true).findAll();
  }

  /// Returns all the labels.
  Future<List<Label>> getAllFiltered(LabelsFilter labelsFilter) async {
    switch (labelsFilter) {
      case LabelsFilter.all:
        return getAll();
      case LabelsFilter.visible:
        return _labels.filter().visibleEqualTo(true).findAll();
      case LabelsFilter.pinned:
        return _labels.filter().pinnedEqualTo(true).findAll();
      case LabelsFilter.hidden:
        return _labels.filter().visibleEqualTo(false).findAll();
    }
  }

  /// Puts the [label] in the database.
  Future<void> put(Label label) async {
    await _database.writeTxn(() async {
      await _labels.put(label);
    });
  }

  /// Puts the [labels] in the database.
  Future<void> putAll(List<Label> labels) async {
    await _database.writeTxn(() async {
      await _labels.putAll(labels);
    });
  }

  /// Deletes the [label] from the database.
  Future<void> delete(Label label) async {
    await _database.writeTxn(() async {
      await _labels.delete(label.id);
    });
  }

  /// Deletes the [labels] from the database.
  Future<void> deleteAll(List<Label> labels) async {
    await _database.writeTxn(() async {
      await _labels.deleteAll(labels.map((label) => label.id).toList());
    });
  }

  /// Deletes all the labels from the database.
  Future<void> clear() async {
    await _database.writeTxn(() async {
      await _labels.where().deleteAll();
    });
  }
}
