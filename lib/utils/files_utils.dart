import 'dart:developer';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:path/path.dart';

/// Writes a file with the [data], in the [directory], with the [filename] and the [mimeType].
///
/// Uses the native APIs to write the file without needing any permissions,
/// so it will only work in the application's own data directory.
Future<bool> _writeFileNative({
  required String directory,
  required String fileName,
  required String mimeType,
  required Uint8List data,
}) async {
  try {
    final path = join(directory, fileName);
    final file = XFile.fromData(data, mimeType: mimeType);

    await file.saveTo(path);
  } catch (exception, stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);

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
    await safStream.writeFileSync(directory, fileName, mimeType, data);
  } catch (exception, stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);

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
      ? await _writeFileNative(directory: directory, fileName: fileName, mimeType: mimeType, data: data)
      : await _writeFileSaf(directory: directory, fileName: fileName, mimeType: mimeType, data: data);
}

/// Returns the URI to the directory picked by the user, with a persisted write permission.
Future<String?> selectDirectory() async {
  return await safUtil.openDirectory(writePermission: true, persistablePermission: true);
}

/// Returns the the file picked by the user, limiting the choice to only files of the [typeGroup].
Future<XFile?> selectFile(XTypeGroup typeGroup) async {
  return await openFile(acceptedTypeGroups: [typeGroup]);
}

/// Returns whether the directory at [path] exists.
Future<bool> doesDirectoryExist(String path) async {
  return await safUtil.exists(path, true);
}
