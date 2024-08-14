import 'dart:developer';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';
import 'package:path/path.dart';

/// Type group corresponding to JSON files.
const typeGroupJson = XTypeGroup(
  label: 'JSON',
  extensions: <String>['json'],
);

/// Returns the export file depending on the [directory] where to save it and its file [extension].
File getExportFile(String directory, String extension) {
  final timestamp = DateTime.timestamp();
  final fileName = 'materialnotes_export_${timestamp.filename}.$extension';
  final filePath = join(directory, fileName);
  final fileUri = Uri.file(filePath);

  return File.fromUri(fileUri)..createSync(recursive: true);
}

/// Returns the path to the directory picked by the user.
Future<String?> pickDirectory() async {
  final directory = await getDirectoryPath();

  if (directory == null) {
    return null;
  }

  return directory;
}

/// Returns the path to the file picked by the user, limiting the choice to only files of the [typeGroup].
Future<XFile?> pickSingleFile(XTypeGroup typeGroup) async {
  return await openFile(acceptedTypeGroups: [typeGroup]);
}

/// Writes the [contents] to the file.
Future<bool> writeStringToFile(File file, String contents) async {
  try {
    await file.writeAsString(contents, mode: FileMode.writeOnly);
  } catch (exception, stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);

    return false;
  }

  return true;
}

/// Writes the [bytes] to the file.
Future<bool> writeBytesToFile(File file, List<int> bytes) async {
  try {
    await file.writeAsBytes(bytes, mode: FileMode.writeOnly);
  } catch (exception, stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);

    return false;
  }

  return true;
}
