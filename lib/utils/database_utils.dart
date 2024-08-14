import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/environment.dart';
import 'package:localmaterialnotes/common/constants/notes.dart';
import 'package:localmaterialnotes/common/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/common/preferences/enums/sort_method.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/pages/settings/dialogs/import_dialog.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:localmaterialnotes/utils/snack_bar_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanitize_filename/sanitize_filename.dart';

/// Utilities for the database.
///
/// This class is a singleton.
class DatabaseUtils {
  static final DatabaseUtils _singleton = DatabaseUtils._internal();

  factory DatabaseUtils() {
    return _singleton;
  }

  DatabaseUtils._internal();

  /// Name of the database.
  final _databaseName = 'materialnotes';

  /// Directory where the database is stored.
  late String _databaseDirectory;

  /// Isar database.
  late Isar _database;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    _databaseDirectory = (await getApplicationDocumentsDirectory()).path;
    _database = await Isar.open(
      [NoteSchema],
      name: _databaseName,
      directory: _databaseDirectory,
    );

    // If the app runs with the 'screenshots' environment parameter,
    // clear all the notes and add the notes for the screenshots
    if (Environment.screenshots) {
      await clear();
      await putAll(screenshotNotes);
    }
    // If the app runs for the first time ever, add the welcome note
    else if (await IsFirstRun.isFirstCall()) {
      await put(welcomeNote);
    }
  }

  /// Returns all the notes.
  ///
  /// Returns the not deleted notes by default, or the deleted ones if [deleted] is set to `true`.
  Future<List<Note>> getAll({bool deleted = false}) async {
    final sortMethod = SortMethod.fromPreference();
    final sortAscending = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

    final sortedByPinned = deleted
        ? _database.notes.where().deletedEqualTo(deleted).sortByPinnedDesc()
        : _database.notes.where().sortByPinnedDesc();

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

  /// Puts the [note] in the database.
  Future<void> put(Note note) async {
    await _database.writeTxn(() async {
      await _database.notes.put(note);
    });
  }

  /// Puts the [notes] in the database.
  Future<void> putAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _database.notes.putAll(notes);
    });
  }

  /// Deletes the [note] from the database.
  Future<void> delete(Note note) async {
    await _database.writeTxn(() async {
      await _database.notes.delete(note.id);
    });
  }

  /// Deletes the [notes] from the database.
  Future<void> deleteAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _database.notes.deleteAll(notes.map((note) => note.id).toList());
    });
  }

  /// Deletes all the deleted notes from the database.
  Future<void> emptyBin() async {
    await _database.writeTxn(() async {
      await _database.notes.where().deletedEqualTo(true).deleteAll();
    });
  }

  /// Deletes all the notes from the database.
  Future<void> clear() async {
    await _database.writeTxn(() async {
      await _database.notes.where().deleteAll();
    });
  }

  /// Exports all the notes in a JSON [file].
  ///
  /// If [encrypt] is enabled, the title and the content of the notes is encrypted with the [password].
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

  /// Automatically exports all the notes in a JSON file.
  ///
  /// If [encrypt] is enabled, the title and the content of the notes is encrypted with the [password].
  Future<bool> autoExportAsJson(bool encrypt, String password) async {
    final file = await AutoExportUtils().getAutoExportFile;

    return await _exportAsJson(encrypt, password, file);
  }

  /// Manually exports all the notes in a JSON file.
  ///
  /// First asks the user to pick a directory where to save the export file.
  ///
  /// If [encrypt] is enabled, the title and the content of the notes is encrypted with the [password].
  Future<bool> manuallyExportAsJson(bool encrypt, String? password) async {
    final exportDirectory = await pickDirectory();

    if (exportDirectory == null) {
      return false;
    }

    final file = getExportFile(exportDirectory, 'json');

    return await _exportAsJson(encrypt, password, file);
  }

  /// Exports all the notes in a Markdown file.
  ///
  /// First asks the user to pick a directory where to save the export file.
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

  /// Imports all the notes from a JSON file picked by the user.
  Future<bool> import(BuildContext context) async {
    final importPlatformFile = await pickSingleFile(typeGroupJson);

    if (importPlatformFile == null) {
      return false;
    }

    final importedString = utf8.decode(await importPlatformFile.readAsBytes());
    var importedJson = jsonDecode(importedString);

    List<Note>? notes;

    // If the imported JSON is just a list, then it's the old export format (before v1.5.0) that just contains
    // the notes list. Otherwise, it's the new export format (after v1.5.0) that contains other data.
    if (importedJson is List) {
      notes = importedJson.map((noteAsJson) {
        return Note.fromJson(noteAsJson as Map<String, dynamic>);
      }).toList();
    } else {
      importedJson = importedJson as Map<String, dynamic>;

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
    }

    await putAll(notes);

    return true;
  }
}
