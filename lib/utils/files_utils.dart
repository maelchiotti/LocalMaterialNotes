import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';
import 'package:path/path.dart';

File getExportFile(String directory, String extension) {
  final timestamp = DateTime.timestamp();
  final fileName = 'materialnotes_export_${timestamp.filename}.$extension';
  final filePath = join(directory, fileName);
  final fileUri = Uri.file(filePath);

  return File.fromUri(fileUri)..createSync(recursive: true);
}

Future<String?> pickDirectory() async {
  final directory = await FilePicker.platform.getDirectoryPath();

  if (directory == null) {
    return null;
  }

  return directory;
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
