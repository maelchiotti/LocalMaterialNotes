import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:shared_storage/shared_storage.dart' as saf;

/// Returns the URI to the directory picked by the user.
Future<Uri?> pickDirectory() async {
  return await saf.openDocumentTree();
}

/// Returns the URI to the file picked by the user, limiting the choice to only files of the [mimeType].
Future<Uri?> pickSingleFile(
  String mimeType, {
  bool persistablePermission = false,
  bool grantWritePermission = false,
}) async {
  final pickedFiles = await saf.openDocument(
    persistablePermission: persistablePermission,
    grantWritePermission: grantWritePermission,
    mimeType: mimeType,
  );

  return pickedFiles?.firstOrNull;
}

/// Writes the [content] to a file with the [mimeType] and the [fileName] at the path of the [parentUri] directory.
Future<bool> writeStringToFile(
  Uri parentUri,
  String mimeType,
  String fileName,
  String content, {
  bool useSaf = true,
}) async {
  return await writeBytesToFile(
    parentUri,
    mimeType,
    fileName,
    Uint8List.fromList(content.codeUnits),
    useSaf: useSaf,
  );
}

/// Writes the [bytes] to a file with the [mimeType] and the [fileName] at the path of the [parentUri] directory.
Future<bool> writeBytesToFile(
  Uri parentUri,
  String mimeType,
  String fileName,
  Uint8List bytes, {
  bool useSaf = true,
}) async {
  try {
    if (useSaf) {
      await saf.createFileAsBytes(
        parentUri,
        mimeType: mimeType,
        displayName: fileName,
        bytes: bytes,
      );
    } else {
      final filePath = join(parentUri.path, fileName);
      final file = File(filePath);

      print(await file.writeAsBytes(bytes));
    }
  } catch (exception, stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);

    return false;
  }

  return true;
}
