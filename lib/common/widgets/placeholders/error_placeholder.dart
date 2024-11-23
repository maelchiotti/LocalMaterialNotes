import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/error_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:localmaterialnotes/utils/snack_bar_utils.dart';
import 'package:localmaterialnotes/utils/utils.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Placeholder widget for an error.
class ErrorPlaceholder extends StatelessWidget {
  /// Default constructor.
  const ErrorPlaceholder({
    super.key,
    required this.exception,
    this.stackTrace,
  });

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
    if (await DatabaseUtils().manuallyExportAsJson(encrypt: false)) {
      SnackBarUtils.info(localizations.snack_bar_export_success).show();
    }
  }

  /// Opens a new GitHub issue.
  void _createGitHubIssue() {
    launchUrl(
      Uri(
        scheme: 'https',
        host: 'github.com',
        path: 'maelchiotti/LocalMaterialNotes/issues/new',
      ),
    );
  }

  /// Sends a bug report mail.
  void _sendMail() {
    final appVersion = InfoUtils().appVersion;
    final buildMode = InfoUtils().buildMode;
    final androidVersion = InfoUtils().androidVersion;
    final brand = InfoUtils().brand;
    final model = InfoUtils().model;

    launchUrl(
      Uri(
        scheme: 'mailto',
        path: contactEmail,
        query: encodeQueryParameters({
          'subject': '[Material Notes] Bug report',
          'body': '\n\n\n----------\nv$appVersion\n$buildMode mode\nAndroid $androidVersion\n$brand $model',
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    // Disable the secure flag until the next restart to allow screenshots
    final isFlagSecureSettingEnabled = PreferenceKey.flagSecure.getPreferenceOrDefault<bool>();
    if (isFlagSecureSettingEnabled) {
      FlagSecure.unset();
    }

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const TopNavigation(
        appbar: ErrorAppBar(),
      ),
      drawer: const SideNavigation(),
      body: Center(
        child: Padding(
          padding: Paddings.page,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  appLocalizations.error_widget_title,
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium,
                ),
                Padding(padding: Paddings.vertical(4.0)),
                Text(
                  appLocalizations.error_widget_description,
                  textAlign: TextAlign.center,
                ),
                if (isFlagSecureSettingEnabled) ...[
                  Padding(padding: Paddings.vertical(4.0)),
                  Text(
                    appLocalizations.error_widget_disabled_secure_flag,
                    textAlign: TextAlign.center,
                    style: textTheme.labelMedium,
                  ),
                ],
                Padding(padding: Paddings.vertical(16.0)),
                ElevatedButton.icon(
                  icon: const Icon(Icons.settings_backup_restore),
                  label: Text(appLocalizations.error_widget_button_export_notes),
                  onPressed: () => _exportNotes(appLocalizations),
                ),
                Padding(padding: Paddings.vertical(16.0)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.copy),
                      label: Text(appLocalizations.error_widget_button_copy_logs),
                      onPressed: () => logger.copyLogs(overrideLocalizations: appLocalizations),
                    ),
                    Padding(padding: Paddings.horizontal(8.0)),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.file_download),
                      label: Text(appLocalizations.error_widget_button_export_logs),
                      onPressed: () => logger.exportLogs(overrideLocalizations: appLocalizations),
                    ),
                  ],
                ),
                Padding(padding: Paddings.vertical(8.0)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      icon: const Icon(SimpleIcons.github),
                      label: Text(appLocalizations.error_widget_button_create_github_issue),
                      onPressed: _createGitHubIssue,
                    ),
                    Padding(padding: Paddings.horizontal(8.0)),
                    FilledButton.icon(
                      icon: const Icon(Icons.mail),
                      label: Text(appLocalizations.error_widget_button_send_mail),
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
