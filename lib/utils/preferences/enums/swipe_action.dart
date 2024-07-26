import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

enum SwipeAction {
  none,
  delete,
  pin,
  ;

  factory SwipeAction.rightFromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.swipeRightAction);

    return preference != null
        ? SwipeAction.values.byName(preference)
        : PreferenceKey.swipeRightAction.defaultValue as SwipeAction;
  }

  factory SwipeAction.leftFromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.swipeLeftAction);

    return preference != null
        ? SwipeAction.values.byName(preference)
        : PreferenceKey.swipeLeftAction.defaultValue as SwipeAction;
  }

  String get title {
    switch (this) {
      case none:
        return localizations.confirmations_title_none;
      case delete:
        return localizations.confirmations_title_irreversible;
      case pin:
        return localizations.confirmations_title_all;
    }
  }
}
