import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/enums/mime_type.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:localmaterialnotes/utils/snack_bar_utils.dart';
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

      _writeLogs(details.exception, details.stack);
    };

    // Intercept all exceptions raised by the platform
    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      handleException(exception, stackTrace);

      return true;
    };
  }

  /// Combines a timestamp, the [exception] and the [stackTrace] into a readable log message.
  String _getLogsMessage(Object exception, StackTrace? stackTrace) {
    final message = StringBuffer();

    message.writeln(DateTime.timestamp().toUtc().toIso8601String());
    message.writeln(exception.toString());

    if (stackTrace != null) {
      message.writeln(stackTrace.toString());
    }

    message.writeln();

    return message.toString();
  }

  /// Prints the [exception] and the [stackTrace] to the console.
  void _printLogs(Object exception, StackTrace? stackTrace) {
    log(exception.toString(), stackTrace: stackTrace);
  }

  /// Writes a timestamp, the [exception] and the [stackTrace] to the log file.
  void _writeLogs(Object exception, StackTrace? stackTrace) {
    _logFile.writeAsStringSync(_getLogsMessage(exception, stackTrace), mode: FileMode.append);
  }

  /// Handles the [exception] and its [stackTrace], printing them to the console and writing them to the log file.
  void handleException(Object exception, StackTrace? stackTrace) {
    // Only print to the console in debug mode.
    if (kDebugMode) {
      _printLogs(exception, stackTrace);
    }

    _writeLogs(exception, stackTrace);
  }

  /// Copies the logs to the clipboard.
  ///
  /// The localizations can be overridden with [overrideLocalizations] to avoid depending on `rootNavigatorKey.context`
  /// to get them in case the error prevented it from being instantiated.
  Future<void> copyLogs({AppLocalizations? overrideLocalizations}) async {
    final appLocalizations = overrideLocalizations ?? localizations;

    final content = await _logFile.readAsString();

    final clipboardData = ClipboardData(text: content);

    await Clipboard.setData(clipboardData);

    SnackBarUtils.info(appLocalizations.snack_bar_logs_copied).show();
  }

  /// Exports the logs to a text file into a directory chosen by the user.
  ///
  /// The localizations can be overridden with [overrideLocalizations] to avoid depending on `rootNavigatorKey.context`
  /// to get them in case the error prevented it from being instantiated.
  Future<bool> exportLogs({AppLocalizations? overrideLocalizations}) async {
    final appLocalizations = overrideLocalizations ?? localizations;

    final exportDirectory = await selectDirectory();

    if (exportDirectory == null) {
      return false;
    }

    final content = await _logFile.readAsString();

    final exported = await writeFileFromString(
      directory: exportDirectory,
      fileName: 'materialnotes_logs.${MimeType.plainText.extension}',
      mimeType: MimeType.plainText.value,
      content: content,
    );

    if (exported) {
      SnackBarUtils.info(appLocalizations.snack_bar_logs_exported).show();
    }

    return exported;
  }
}
