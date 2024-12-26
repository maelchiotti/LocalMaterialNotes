import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart' hide FileOutput;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../l10n/app_localizations/app_localizations.g.dart';
import '../../utils/files_utils.dart';
import '../../utils/snack_bar_utils.dart';
import '../constants/constants.dart';
import '../enums/mime_type.dart';
import '../extensions/date_time_extensions.dart';
import '../extensions/string_extension.dart';
import 'filters/debug_filter.dart';
import 'filters/release_filter.dart';

/// Exceptions logger.
class AppLogger {
  static final AppLogger _singleton = AppLogger._internal();

  /// Logger that outputs all exceptions to the console or a log file.
  factory AppLogger() => _singleton;

  AppLogger._internal();

  late final String _logFilesDirectory;

  /// Logger that prints to the console (only in debug mode).
  late final Logger _consoleLogger;

  /// Logger that writes to a file (only in release mode).
  late final Logger _fileLogger;

  /// Name of the latest log file.
  final _latestLogFileName = 'latest.log';

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    _logFilesDirectory = join((await getApplicationSupportDirectory()).path, 'logs');

    _consoleLogger = Logger(
      filter: DebugFilter(),
      printer: PrettyPrinter(
        methodCount: 5,
        errorMethodCount: 20,
        dateTimeFormat: DateTimeFormat.onlyTime,
      ),
    );
    _fileLogger = Logger(
      filter: ReleaseFilter(),
      printer: PrettyPrinter(
        methodCount: 25,
        errorMethodCount: 100,
        colors: false,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),
      output: AdvancedFileOutput(
        path: _logFilesDirectory,
        maxRotatedFilesCount: 100,
      ),
    );

    // Intercept all exceptions raised by Flutter and by the platform to write them to the log file in release mode
    FlutterError.onError = (details) {
      FlutterError.presentError(details);

      _fileLogger.e(details.exceptionAsString().firstLine, error: details.exception, stackTrace: details.stack);
    };
    PlatformDispatcher.instance.onError = (exception, stackTrace) {
      e(exception.toString().firstLine ?? 'Unknown exception', exception, stackTrace);

      return true;
    };
  }

  /// Logs an information message.
  void i(String message, [Object? exception, StackTrace? stackTrace]) {
    _consoleLogger.i(message, error: exception, stackTrace: stackTrace);
    _fileLogger.i(message.firstLine, error: exception, stackTrace: stackTrace);
  }

  /// Logs a warning message.
  void w(String message, [Object? exception, StackTrace? stackTrace]) {
    _consoleLogger.w(message, error: exception, stackTrace: stackTrace);
    _fileLogger.w(message.firstLine, error: exception, stackTrace: stackTrace);
  }

  /// Logs an error message.
  void e(String message, [Object? exception, StackTrace? stackTrace]) {
    _consoleLogger.e(message, error: exception, stackTrace: stackTrace);
    _fileLogger.e(message.firstLine, error: exception, stackTrace: stackTrace);
  }

  /// Logs a fatal message.
  void f(String message, [Object? exception, StackTrace? stackTrace]) {
    _consoleLogger.f(message, error: exception, stackTrace: stackTrace);
    _fileLogger.f(message.firstLine, error: exception, stackTrace: stackTrace);
  }

  /// Copies the logs to the clipboard.
  ///
  /// The localizations can be overridden with [overrideLocalizations] to avoid depending on `rootNavigatorKey.context`
  /// to get them in case the error prevented it from being instantiated.
  Future<void> copyLogs({AppLocalizations? overrideLocalizations}) async {
    final localizations = overrideLocalizations ?? l;

    final file = File(join(_logFilesDirectory, _latestLogFileName));
    final logs = await file.exists() ? await file.readAsString() : 'The logs are empty.';

    final clipboardData = ClipboardData(text: logs);
    await Clipboard.setData(clipboardData);

    SnackBarUtils.info(localizations.snack_bar_logs_copied).show();
  }

  /// Exports the logs to a text file into a directory chosen by the user.
  ///
  /// The localizations can be overridden with [overrideLocalizations] to avoid depending on `rootNavigatorKey.context`
  /// to get them in case the error prevented it from being instantiated.
  Future<bool> exportLogs({AppLocalizations? overrideLocalizations}) async {
    final localizations = overrideLocalizations ?? l;

    final exportDirectory = await selectDirectory();

    if (exportDirectory == null) {
      return false;
    }

    final file = File(join(_logFilesDirectory, _latestLogFileName));
    final logs = await file.exists() ? await file.readAsString() : 'The logs are empty.';

    final exported = await writeFileFromString(
      directory: exportDirectory,
      fileName: 'materialnotes_logs_${DateTime.now().filename}.${MimeType.log.extension}',
      mimeType: MimeType.log.value,
      content: logs,
    );

    if (exported) {
      SnackBarUtils.info(localizations.snack_bar_logs_exported).show();
    }

    return exported;
  }
}
