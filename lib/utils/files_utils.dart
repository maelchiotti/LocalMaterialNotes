import 'dart:developer';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';

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

/// Writes a file with the [data], in the [directory], with the [filename] and the [mimeType].
Future<bool> writeFileSaf(
  String directory,
  String fileName,
  String mimeType,
  Uint8List data,
) async {
  try {
    await safStream.writeFileSync(directory, fileName, mimeType, data);
  } catch (exception, stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);

    return false;
  }

  return true;
}
