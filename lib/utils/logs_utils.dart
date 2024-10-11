import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:localmaterialnotes/common/enums/mime_type.dart';
import 'package:localmaterialnotes/common/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// Utilities for logging exceptions to the console and to a log file.
///
/// This class is a singleton.
class LogsUtils {
  static final LogsUtils _singleton = LogsUtils._internal();

  /// Default constructor.
  factory LogsUtils() {
    return _singleton;
  }

  LogsUtils._internal();

  /// File that contains all the logs.
  late final File _logFile;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    final baseDirectory = await getDownloadsDirectory() ?? await getApplicationSupportDirectory();
    final directoryPath = join(baseDirectory.path, 'logs');
    final directory = Directory(directoryPath);
    await directory.create(recursive: true);
    final logFilePath = join(directory.path, 'logs.${MimeType.plainText.extension}');

    _logFile = File(logFilePath);

    // Intercept all exceptions raised by Flutter
    FlutterError.onError = (details) {
      FlutterError.presentError(details);

      writeLogs(details.exception, details.stack);
    };

    // Intercept all exceptions raised by the platform
    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      handleException(exception, stackTrace);

      return true;
    };
  }

  /// Combines a timestamp, the [exception] and the [stackTrace] into a readable log message.
  String getLogsMessage(Object exception, StackTrace? stackTrace) {
    final message = StringBuffer();

    message.writeln(DateTime.timestamp().toUtc().log);
    message.writeln(exception.toString());

    if (stackTrace != null) {
      message.writeln(stackTrace.toString());
    }

    message.write('\n');

    return message.toString();
  }

  /// Prints the [exception] and the [stackTrace] to the console.
  void printLogs(Object exception, StackTrace? stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);
  }

  /// Writes a timestamp, the [exception] and the [stackTrace] to the log file.
  void writeLogs(Object exception, StackTrace? stackTrace) {
    _logFile.writeAsStringSync(getLogsMessage(exception, stackTrace), mode: FileMode.append);
  }

  /// Exports the logs from the [exception] and the [stackTrace] to a text file into a directory chosen by the user.
  Future<bool> exportLogs(Object exception, StackTrace? stackTrace) async {
    final exportDirectory = await selectDirectory();

    if (exportDirectory == null) {
      return false;
    }

    final data = Uint8List.fromList(getLogsMessage(exception, stackTrace).codeUnits);

    return await writeFile(
      directory: exportDirectory,
      fileName: 'logs.${MimeType.plainText.extension}',
      mimeType: MimeType.plainText.value,
      data: data,
    );
  }

  /// Handles the [exception] and its [stackTrace], printing them to the console and writing them to the log file.
  void handleException(Object exception, StackTrace? stackTrace) {
    // Only print to the console in debug mode.
    if (kDebugMode) {
      printLogs(exception, stackTrace);
    }

    writeLogs(exception, stackTrace);
  }
}
