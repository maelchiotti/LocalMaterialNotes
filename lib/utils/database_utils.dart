import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';
import 'package:localmaterialnotes/l10n/hardcoded_localizations.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanitize_filename/sanitize_filename.dart';
import 'package:shared_storage/shared_storage.dart' as saf;

class DatabaseUtils {
  static final DatabaseUtils _singleton = DatabaseUtils._internal();

  factory DatabaseUtils() {
    return _singleton;
  }

  DatabaseUtils._internal();

  final _databaseName = 'materialnotes';
  late String _databaseDirectory;
  late Isar _database;

  Future<void> init() async {
    _databaseDirectory = (await getApplicationDocumentsDirectory()).path;
    _database = await Isar.open(
      [NoteSchema],
      name: _databaseName,
      directory: _databaseDirectory,
    );

    if (await IsFirstRun.isFirstCall()) {
      await put(welcomeNote);
    }
  }

  Future<List<Note>> getAll({bool? deleted}) async {
    final sortMethod = SortMethod.fromPreference();
    final sortAscending = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

    final sortedByPinned = deleted == null
        ? _database.notes.where().sortByPinnedDesc()
        : _database.notes.where().deletedEqualTo(deleted).sortByPinnedDesc();

    switch (sortMethod) {
      case SortMethod.date:
        return sortAscending
            ? await sortedByPinned.thenByEditedTime().findAll()
            : await sortedByPinned.thenByEditedTimeDesc().findAll();
      case SortMethod.title:
        return sortAscending
            ? await sortedByPinned.thenByTitle().findAll()
            : await sortedByPinned.thenByTitleDesc().findAll();
      default:
        throw Exception();
    }
  }

  Future<void> put(Note note) async {
    await _database.writeTxn(() async {
      await _database.notes.put(note);
    });
  }

  Future<void> putAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _database.notes.putAll(notes);
    });
  }

  Future<void> delete(Note note) async {
    await _database.writeTxn(() async {
      await _database.notes.delete(note.isarId);
    });
  }

  Future<void> deleteAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _database.notes.deleteAll(notes.map((note) => note.isarId).toList());
    });
  }

  Future<void> emptyBin() async {
    await _database.writeTxn(() async {
      await _database.notes.where().deletedEqualTo(true).deleteAll();
    });
  }

  Future<bool> isBinEmpty() async {
    return await _database.notes.where().deletedEqualTo(true).isEmpty();
  }

  Future<Uri?> _getDirectory() async {
    final directory = await saf.openDocumentTree();

    if (directory == null) {
      return null;
    }

    return directory;
  }

  Future<bool> _export(Uri directory, String mimeType, String extension, Uint8List bytes) async {
    final timestamp = DateTime.timestamp();
    final filename = 'materialnotes_export_${timestamp.filename}';

    await saf.createFile(
      directory,
      mimeType: mimeType,
      displayName: filename,
      bytes: bytes,
    );

    return true;
  }

  Future<bool> exportAsJson() async {
    final directory = await _getDirectory();

    if (directory == null) {
      return false;
    }

    final notes = await getAll();
    final notesAsJson = jsonEncode(notes);

    return await _export(directory, 'application/json', 'json', Uint8List.fromList(utf8.encode(notesAsJson)));
  }

  Future<bool> exportAsMarkdown() async {
    final directory = await _getDirectory();

    if (directory == null) {
      return false;
    }

    final notes = await getAll();
    final archive = Archive();

    for (final note in notes) {
      final bytes = Uint8List.fromList(utf8.encode(note.markdown));
      final filename = sanitizeFilename('${note.title} (${note.createdTime.filename}).md');

      archive.addFile(ArchiveFile(filename, bytes.length, bytes));
    }

    final encodedArchive = ZipEncoder().encode(archive);

    if (encodedArchive == null) {
      return false;
    }

    return await _export(directory, 'application/zip', 'zip', Uint8List.fromList(encodedArchive));
  }

  Future<bool> import() async {
    final importFiles = await saf.openDocument(
      grantWritePermission: false,
      mimeType: 'application/json',
    );

    if (importFiles == null || importFiles.isEmpty) {
      return false;
    }

    final importedData = await saf.getDocumentContent(importFiles.first);

    if (importedData == null) {
      throw Exception(localizations.error_read_file);
    }

    final importedString = utf8.decode(importedData);
    final notesJson = jsonDecode(importedString) as List;
    final notes = notesJson.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();

    await putAll(notes);

    return true;
  }
}
