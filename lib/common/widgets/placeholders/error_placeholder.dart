import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations/app_localizations.g.dart';
import '../../../services/backup/backup_service.dart';
import '../../constants/constants.dart' hide l;
import '../../constants/paddings.dart';
import '../../navigation/side_navigation.dart';
import '../../preferences/preference_key.dart';
import '../../system_utils.dart';
import '../../ui/snack_bar_utils.dart';

/// Placeholder widget for an error.
class ErrorPlaceholder extends StatelessWidget {
  /// Default constructor.
  const ErrorPlaceholder({super.key, required this.exception, this.stackTrace});

  /// Constructor from [errorDetails].
  ErrorPlaceholder.errorDetails(FlutterErrorDetails errorDetails, {super.key})
    : exception = errorDetails.exception,
      stackTrace = errorDetails.stack;

  /// The exception that was raised.
  final Object exception;

  /// the stack trace of the exception.
  final StackTrace? stackTrace;

  /// Exports the notes as JSON.
  Future<void> _exportNotes(AppLocalizations localizations) async {
    if (await ManualBackupService().manuallyExportAsJson(encrypt: false)) {
      SnackBarUtils().show(text: localizations.snack_bar_export_success);
    }
  }

  /// Opens a new GitHub issue.
  void _createGitHubIssue() {
    launchUrl(Uri(scheme: 'https', host: 'github.com', path: 'maelchiotti/LocalMaterialNotes/issues/new'));
  }

  /// Sends a bug report mail.
  void _sendMail() {
    final systemUtils = SystemUtils();

    final appVersion = systemUtils.appVersion;
    final buildMode = systemUtils.buildMode;
    final androidVersion = systemUtils.androidVersion;
    final brand = systemUtils.brand;
    final model = systemUtils.model;

    launchUrl(
      Uri(
        scheme: 'mailto',
        path: contactEmail,
        query: systemUtils.encodeQueryParameters({
          'subject': '[Material Notes] Bug report',
          'body': '\n\n\n----------\nv$appVersion\n$buildMode mode\nAndroid $androidVersion\n$brand $model',
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    // Disable the secure flag until the next restart to allow screenshots
    final isFlagSecureSettingEnabled = PreferenceKey.flagSecure.preferenceOrDefault;
    if (isFlagSecureSettingEnabled) {
      FlagSecure.unset();
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.error_widget_title)),
      drawer: const SideNavigation(),
      body: Center(
        child: Padding(
          padding: Paddings.page,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(l.error_widget_title, textAlign: TextAlign.center, style: textTheme.titleMedium),
                Padding(padding: Paddings.vertical(4.0)),
                Text(l.error_widget_description, textAlign: TextAlign.center),
                if (isFlagSecureSettingEnabled) ...[
                  Padding(padding: Paddings.vertical(4.0)),
                  Text(l.error_widget_disabled_secure_flag, textAlign: TextAlign.center, style: textTheme.labelMedium),
                ],
                Padding(padding: Paddings.vertical(16.0)),
                ElevatedButton.icon(
                  icon: const Icon(Icons.settings_backup_restore),
                  label: Text(l.error_widget_button_export_notes),
                  onPressed: () => _exportNotes(l),
                ),
                Padding(padding: Paddings.vertical(16.0)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.copy),
                      label: Text(l.error_widget_button_copy_logs),
                      onPressed: () => logger.copyLogs(overrideLocalizations: l),
                    ),
                    Padding(padding: Paddings.horizontal(8.0)),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.file_download),
                      label: Text(l.error_widget_button_export_logs),
                      onPressed: () => logger.exportLogs(overrideLocalizations: l),
                    ),
                  ],
                ),
                Padding(padding: Paddings.vertical(8.0)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      icon: const Icon(SimpleIcons.github),
                      label: Text(l.error_widget_button_create_github_issue),
                      onPressed: _createGitHubIssue,
                    ),
                    Padding(padding: Paddings.horizontal(8.0)),
                    FilledButton.icon(
                      icon: const Icon(Icons.mail),
                      label: Text(l.error_widget_button_send_mail),
                      onPressed: _sendMail,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
