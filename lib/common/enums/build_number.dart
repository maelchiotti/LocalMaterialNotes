import 'package:localmaterialnotes/utils/info_utils.dart';

/// Important build number.
enum BuildNumber {
  /// v1.9.0: backups contain labels.
  backupLabels(200),

  /// v1.9.0: backups contain preferences.
  backupPreferences(190),
  ;

  /// The build number.
  final int buildNumber;

  /// Important build number.
  ///
  /// Used to check if a functionality is present in the application.
  const BuildNumber(this.buildNumber);

  /// Returns whether [buildNumber] is equal or greater than the current build number of the application.
  bool get isCurrentOrGreater {
    return InfoUtils().buildNumber >= buildNumber;
  }
}
