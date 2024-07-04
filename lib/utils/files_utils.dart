import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';
import 'package:path/path.dart';

File getExportFile(Uri directoryUri, String extension, {List<String>? intermediateDirectories}) {
  final timestamp = DateTime.timestamp();
  final filename = 'materialnotes_export_${timestamp.filename}.$extension';
  final parts = [directoryUri.path, ...?intermediateDirectories, filename];
  final filepath = joinAll(parts);

  return File(filepath)..createSync(recursive: true);
}

Future<Uri?> pickDirectory() async {
  final directoryPath = await FilePicker.platform.getDirectoryPath();

  if (directoryPath == null) {
    return null;
  }

  return Uri.directory(directoryPath);
}

Future<PlatformFile?> pickSingleFile(FileType type, List<String> allowedExtensions) async {
  final filePickerResult = await FilePicker.platform.pickFiles(
    type: type,
    allowedExtensions: allowedExtensions,
  );

  return filePickerResult?.files.single;
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
