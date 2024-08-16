import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';

/// Lists the actions to trigger when swiping on a note tile.
enum SwipeAction {
  /// Don't trigger any action.
  disabled,

  /// Delete the note.
  delete,

  /// Pin the note.
  pin,
  ;

  /// Returns the value of the right swipe action preference if set, or its default value otherwise.
  factory SwipeAction.rightFromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.swipeRightAction);

    return preference != null
        ? SwipeAction.values.byName(preference)
        : PreferenceKey.swipeRightAction.defaultValue as SwipeAction;
  }

  /// Returns the value of the left swipe action preference if set, or its default value otherwise.
  factory SwipeAction.leftFromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.swipeLeftAction);

    return preference != null
        ? SwipeAction.values.byName(preference)
        : PreferenceKey.swipeLeftAction.defaultValue as SwipeAction;
  }

  /// Returns whether the swipe action is enabled.
  bool get isEnabled {
    return this != disabled;
  }

  /// Returns whether the swipe action is disabled.
  bool get isDisabled {
    return this == disabled;
  }

  /// Returns the title of the preference for the settings page.
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
