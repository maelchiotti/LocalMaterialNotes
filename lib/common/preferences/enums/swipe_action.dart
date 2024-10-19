import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';

// ignore_for_file: public_member_api_docs

/// Lists the actions to trigger when swiping on a note tile.
enum SwipeAction {
  /// The swipe action is disabled.
  disabled(Icons.hide_source),

  /// Toggle the pin status of the note.
  togglePin(Icons.push_pin, alternativeIcon: Icons.push_pin_outlined),

  /// Delete the note.
  ///
  /// This action is [dangerous].
  delete(Icons.delete, dangerous: true),

  /// Share the note.
  share(Icons.share),

  /// Copy the note to the clipboard.
  copy(Icons.copy),
  ;

  /// Icon of the menu option.
  final IconData? icon;

  /// Alternative icon of the menu option if the option has two states.
  final IconData? alternativeIcon;

  /// Whether the action is a dangerous one.
  ///
  /// Changes the background, text and icon colors to red.
  final bool? dangerous;

  /// The swipe action that can be performed on a note tile.
  ///
  /// A swipe action is represented by an [icon] and a [title]. If it has two states, it can have an [alternativeIcon].
  ///
  /// If it performs a dangerous action, is can be marked as [dangerous].
  const SwipeAction(this.icon, {this.alternativeIcon, this.dangerous});

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

  /// Returns the title of the swipe action.
  ///
  /// Returns the alternative title if [alternative] is set to `true`.
  String title([bool alternative = false]) {
    switch (this) {
      case disabled:
        return l.action_disabled;
      case delete:
        return l.action_delete;
      case togglePin:
        return l.action_pin;
      case share:
        return l.action_share;
      case copy:
        return flutterL?.copyButtonLabel ?? 'Copy';
    }
  }
}
