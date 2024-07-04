import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';

// ignore_for_file: unreachable_from_main

class AutoExportUtils {
  static final AutoExportUtils _singleton = AutoExportUtils._internal();

  factory AutoExportUtils() {
    return _singleton;
  }

  AutoExportUtils._internal();

  late Workmanager workManager;

  final _uniqueName = 'material_notes_task_auto_backup';
  final _taskName = 'Material Notes | Auto backup';

  final _downloadDirectoryPath = '/storage/emulated/0/Download';
  final _intermediateDirectories = ['Material Notes', 'backups'];

  Future<Uri?> get _autoExportDirectory async {
    final downloadsDirectory = Directory(_downloadDirectoryPath);

    if (!downloadsDirectory.existsSync()) {
      final externalStorageDirectory = await getExternalStorageDirectory();

      return externalStorageDirectory?.uri;
    }

    return downloadsDirectory.uri;
  }

  Future<bool> get hasAutoExportDirectory async {
    return await _autoExportDirectory != null;
  }

  Future<File?> get getAutoExportFile async {
    if (!(await hasAutoExportDirectory)) {
      return null;
    }

    final downloadDirectory = (await _autoExportDirectory)!;

    return getExportFile(
      downloadDirectory,
      'json',
      intermediateDirectories: _intermediateDirectories,
    );
  }

  Future<void> ensureInitialized() async {
    Workmanager().initialize(
      autoExportCallbackDispatcher,
      isInDebugMode: kDebugMode,
    );
  }

  void register(Duration duration) {
    Workmanager().registerPeriodicTask(
      _uniqueName,
      _taskName,
      frequency: duration,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: true,
        requiresCharging: true,
        requiresDeviceIdle: true,
      ),
    );
  }

  void cancel() {
    Workmanager().cancelByUniqueName(_uniqueName);
  }
}

@pragma('vm:entry-point')
void autoExportCallbackDispatcher() {
  Workmanager().executeTask((_, __) async {
    await PreferencesUtils().ensureInitialized();
    await DatabaseUtils().ensureInitialized();

    try {
      await DatabaseUtils().autoExportAsJson();
    } catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);

      return Future.value(false);
    }

    return Future.value(true);
  });
}
