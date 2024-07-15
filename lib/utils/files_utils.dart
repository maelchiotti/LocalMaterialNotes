import 'dart:developer';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';
import 'package:path/path.dart';

const typeGroupJson = XTypeGroup(
  label: 'JSON',
  extensions: <String>['json'],
);

File getExportFile(String directory, String extension) {
  final timestamp = DateTime.timestamp();
  final fileName = 'materialnotes_export_${timestamp.filename}.$extension';
  final filePath = join(directory, fileName);
  final fileUri = Uri.file(filePath);

  return File.fromUri(fileUri)..createSync(recursive: true);
}

Future<String?> pickDirectory() async {
  final directory = await getDirectoryPath();

  if (directory == null) {
    return null;
  }

  return directory;
}

Future<XFile?> pickSingleFile(XTypeGroup typeGroup) async {
  return await openFile(acceptedTypeGroups: [typeGroup]);
}

Future<bool> writeStringToFile(File file, String contents) async {
  try {
    await file.writeAsString(contents, mode: FileMode.writeOnly);
  } catch (exception, stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);

    return false;
  }

  return true;
}

Future<bool> writeBytesToFile(File file, List<int> bytes) async {
  try {
    await file.writeAsBytes(bytes, mode: FileMode.writeOnly);
  } catch (exception, stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);

    return false;
  }

  return true;
}
