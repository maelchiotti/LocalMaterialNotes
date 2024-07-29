import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

enum SwipeAction {
  disabled,
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

  bool get isEnabled {
    return this != disabled;
  }

  bool get isDisabled {
    return this == disabled;
  }

  String get title {
    switch (this) {
      case disabled:
        return localizations.swipe_action_disabled;
      case delete:
        return localizations.swipe_action_delete;
      case pin:
        return localizations.swipe_action_pin;
    }
  }
}
