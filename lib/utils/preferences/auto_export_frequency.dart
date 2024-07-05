import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

enum AutoExportFrequency {
  disabled,
  day(Duration(days: 1)),
  threeDays(Duration(days: 3)),
  week(Duration(days: 7)),
  twoWeeks(Duration(days: 14)),
  month(Duration(days: 30)),
  ;

  final Duration? duration;

  const AutoExportFrequency([this.duration]);

  factory AutoExportFrequency.fromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.autoExportFrequency);

    return preference != null
        ? AutoExportFrequency.values.byName(preference)
        : PreferenceKey.autoExportFrequency.defaultValue as AutoExportFrequency;
  }

  String get title {
    switch (this) {
      case disabled:
        return localizations.settings_auto_export_disabled;
      case day:
        return localizations.settings_auto_export_day;
      case threeDays:
        return localizations.settings_auto_export_three_days;
      case week:
        return localizations.settings_auto_export_week;
      case twoWeeks:
        return localizations.settings_auto_export_two_weeks;
      case month:
        return localizations.settings_auto_export_month;
    }
  }
}
