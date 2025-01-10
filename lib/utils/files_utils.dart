import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';

import '../common/constants/constants.dart';
import '../services/backup/auto_backup_service.dart';

/// Writes a file with the [data], in the [directory], with the [filename].
///
/// Uses the native APIs to write the file without needing any permissions,
/// so it will only work in the application's own data directory.
Future<bool> _writeFileNative({
  required String directory,
  required String fileName,
  required Uint8List data,
}) async {
  try {
    final path = join(directory, fileName);
    final file = File(path);

    await file.writeAsBytes(data);
  } catch (exception, stackTrace) {
    logger.e(exception.toString(), exception, stackTrace);

    return false;
  }

  return true;
}

/// Writes a file with the [data], in the [directory], with the [filename] and the [mimeType].
///
/// Uses the Storage Access Framework (SAF) APIs that should have given a persisted permission
/// to write files at that location.
Future<bool> _writeFileSaf({
  required String directory,
  required String fileName,
  required String mimeType,
  required Uint8List data,
}) async {
  try {
    await safStream.writeFileBytes(directory, fileName, mimeType, data);
  } catch (exception, stackTrace) {
    logger.e(exception.toString(), exception, stackTrace);

    return false;
  }

  return true;
}

/// Writes a file with the [data], in the [directory], with the [filename] and the [mimeType].
///
/// Uses the Storage Access Framework (SAF) APIs only if the directory is not the default export directory.
Future<bool> writeFile({
  required String directory,
  required String fileName,
  required String mimeType,
  required Uint8List data,
}) async {
  final isDefaultDirectory = directory == await AutoExportUtils().autoExportDirectoryDefault;

  return isDefaultDirectory
      ? await _writeFileNative(directory: directory, fileName: fileName, data: data)
      : await _writeFileSaf(directory: directory, fileName: fileName, mimeType: mimeType, data: data);
}

/// Writes a file with the [content] as a [String], in the [directory], with the [filename] and the [mimeType].
///
/// Uses the Storage Access Framework (SAF) APIs only if the directory is not the default export directory.
Future<bool> writeFileFromString({
  required String directory,
  required String fileName,
  required String mimeType,
  required String content,
}) async {
  final data = utf8.encode(content);

  return await writeFile(directory: directory, fileName: fileName, mimeType: mimeType, data: data);
}

/// Returns the URI to the directory picked by the user, with a persisted write permission.
Future<String?> selectDirectory() async =>
    (await safUtil.pickDirectory(writePermission: true, persistablePermission: true))?.uri;

/// Returns the the file picked by the user, limiting the choice to only files of the [mimeType].
Future<Uint8List?> selectAndReadFile(String mimeType) async {
  final file = (await safUtil.pickFile(mimeTypes: [mimeType]))?.uri;

  if (file == null) {
    return null;
  }

  return await safStream.readFileBytes(file);
}

/// Returns whether the directory at [path] exists.
Future<bool> doesDirectoryExist(String path) async => await safUtil.exists(path, true);

/// Creates the directory at [path], recursively creating the parent directories if necessary.
Future<void> createDirectory(String path) async {
  await Directory(path).create(recursive: true);
}
