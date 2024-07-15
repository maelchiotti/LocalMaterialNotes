import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';
import 'package:localmaterialnotes/common/dialogs/import_dialog.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';
import 'package:localmaterialnotes/utils/snack_bar_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanitize_filename/sanitize_filename.dart';

class DatabaseUtils {
  static final DatabaseUtils _singleton = DatabaseUtils._internal();

  factory DatabaseUtils() {
    return _singleton;
  }

  DatabaseUtils._internal();

  final _databaseName = 'materialnotes';
  late String _databaseDirectory;
  late Isar _database;

  Future<void> ensureInitialized() async {
    _databaseDirectory = (await getApplicationDocumentsDirectory()).path;
    _database = await Isar.open(
      [NoteSchema],
      name: _databaseName,
      directory: _databaseDirectory,
    );

    if (await IsFirstRun.isFirstCall()) {
      await put(Note.welcome());
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
        throw Exception('The sort methode is not set: $sortMethod');
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
      await _database.notes.delete(note.id);
    });
  }

  Future<void> deleteAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _database.notes.deleteAll(notes.map((note) => note.id).toList());
    });
  }

  Future<void> emptyBin() async {
    await _database.writeTxn(() async {
      await _database.notes.where().deletedEqualTo(true).deleteAll();
    });
  }

  Future<bool> _exportAsJson(bool encrypt, String? password, File file) async {
    var notes = await getAll();

    if (encrypt && password != null && password.isNotEmpty) {
      notes = notes.map((note) => note.encrypted(password)).toList();
    }

    final version = InfoUtils().appVersion;

    final exportData = {
      'version': version,
      'encrypted': encrypt,
      'notes': notes,
    };
    final exportDataAsJson = jsonEncode(exportData);

    return await writeStringToFile(file, exportDataAsJson);
  }

  Future<bool> autoExportAsJson(bool encrypt, String password) async {
    final file = await AutoExportUtils().getAutoExportFile;

    return await _exportAsJson(encrypt, password, file);
  }

  Future<bool> manuallyExportAsJson(bool encrypt, String? password) async {
    final exportDirectory = await pickDirectory();

    if (exportDirectory == null) {
      return false;
    }

    final file = getExportFile(exportDirectory, 'json');

    return await _exportAsJson(encrypt, password, file);
  }

  Future<bool> exportAsMarkdown() async {
    final exportDirectory = await pickDirectory();

    if (exportDirectory == null) {
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

    final file = getExportFile(exportDirectory, 'zip');

    return await writeBytesToFile(file, encodedArchive);
  }

  Future<bool> import(BuildContext context) async {
    final importPlatformFile = await pickSingleFile(typeGroupJson);

    if (importPlatformFile == null) {
      return false;
    }

    final importedString = await importPlatformFile.readAsString();
    var importedJson = jsonDecode(importedString);

    // Old incompatible export format that just contains the notes list
    if (importedJson is List) {
      SnackBarUtils.error(
        localizations.settings_import_incompatible_prior_v1_5_0,
        duration: const Duration(seconds: 8),
      ).show();

      return false;
    }

    importedJson = importedJson as Map<String, dynamic>;

    List<Note>? notes;
    final encrypted = importedJson['encrypted'] as bool;
    final notesAsJson = importedJson['notes'] as List;

    if (encrypted && context.mounted) {
      final password = await showAdaptiveDialog<String>(
        context: context,
        builder: (context) => ImportDialog(title: localizations.settings_import),
      );

      if (password == null) {
        return false;
      }

      try {
        notes = notesAsJson.map((noteAsJsonEncrypted) {
          return Note.fromJsonEncrypted(
            noteAsJsonEncrypted as Map<String, dynamic>,
            password,
          );
        }).toList();
      } catch (exception, stackTrace) {
        log(exception.toString(), stackTrace: stackTrace);

        SnackBarUtils.error(
          localizations.dialog_import_encryption_password_error,
          duration: const Duration(seconds: 8),
        ).show();

        return false;
      }
    } else {
      notes = notesAsJson.map((noteAsJson) {
        return Note.fromJson(noteAsJson as Map<String, dynamic>);
      }).toList();
    }

    await putAll(notes);

    return true;
  }
}
