import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../extensions/iterable_extension.dart';
import '../preference_key.dart';

/// Action to trigger when swiping on a note tile.
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

  /// Icon of the swipe action.
  final IconData icon;

  /// Alternative icon of the swipe action if the action has two states.
  final IconData? alternativeIcon;

  /// Whether the swipe action is a dangerous one.
  ///
  /// Changes the background, text and icon colors to red.
  final bool dangerous;

  /// The swipe action that should be performed on a note tile when swiped.
  ///
  /// A swipe action is represented by an [icon] and a [title]. If it has two states, it can have an [alternativeIcon].
  ///
  /// If it performs a dangerous action, is can be marked as [dangerous].
  const SwipeAction(this.icon, {this.alternativeIcon, this.dangerous = false});

  /// Returns the value of the right swipe action preference if set, or its default value otherwise.
  factory SwipeAction.rightFromPreference() {
    final swipeRightAction = SwipeAction.values.byNameOrNull(
      PreferenceKey.swipeRightAction.getPreference(),
    );

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.swipeRightAction.reset();

      return SwipeAction.values.byName(PreferenceKey.swipeRightAction.defaultValue);
    }

    return swipeRightAction;
  }

  /// Returns the value of the left swipe action preference if set, or its default value otherwise.
  factory SwipeAction.leftFromPreference() {
    final swipeRightAction = SwipeAction.values.byNameOrNull(
      PreferenceKey.swipeLeftAction.getPreference(),
    );

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.swipeLeftAction.reset();

      return SwipeAction.values.byName(PreferenceKey.swipeLeftAction.defaultValue);
    }

    return swipeRightAction;
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
        return alternative ? l.action_unpin : l.action_pin;
      case share:
        return l.action_share;
      case copy:
        return flutterL?.copyButtonLabel ?? 'Copy';
    }
  }
}
