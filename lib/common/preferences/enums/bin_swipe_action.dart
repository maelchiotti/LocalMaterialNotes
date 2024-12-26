import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../extensions/iterable_extension.dart';
import '../preference_key.dart';

/// Action to trigger when swiping on a note tile of a deleted note.
enum BinSwipeAction {
  /// The swipe action is disabled.
  disabled(Icons.hide_source),

  /// Restore the note.
  restore(Icons.restore_from_trash),

  /// Permanently delete the note.
  ///
  /// This action is [dangerous].
  permanentlyDelete(Icons.delete_forever, dangerous: true),
  ;

  /// Icon of the swipe action.
  final IconData icon;

  /// Whether the swipe action is a dangerous one.
  ///
  /// Changes the background, text and icon colors to red.
  final bool dangerous;

  /// The swipe action that should be performed on a note tile when swiped.
  ///
  /// A swipe action is represented by an [icon] and a [title].
  ///
  /// If it performs a dangerous action, is can be marked as [dangerous].
  const BinSwipeAction(this.icon, {this.dangerous = false});

  /// Returns the value of the right swipe action preference if set, or its default value otherwise.
  factory BinSwipeAction.rightFromPreference() {
    final swipeRightAction = BinSwipeAction.values.byNameOrNull(
      PreferenceKey.binSwipeRightAction.getPreference(),
    );

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.binSwipeRightAction.reset();

      return BinSwipeAction.values.byName(PreferenceKey.binSwipeRightAction.defaultValue);
    }

    return swipeRightAction;
  }

  /// Returns the value of the left swipe action preference if set, or its default value otherwise.
  factory BinSwipeAction.leftFromPreference() {
    final swipeRightAction = BinSwipeAction.values.byNameOrNull(
      PreferenceKey.binSwipeLeftAction.getPreference(),
    );

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.binSwipeLeftAction.reset();

      return BinSwipeAction.values.byName(PreferenceKey.binSwipeLeftAction.defaultValue);
    }

    return swipeRightAction;
  }

  /// Returns whether the swipe action is enabled.
  bool get isEnabled => this != disabled;

  /// Returns whether the swipe action is disabled.
  bool get isDisabled => this == disabled;

  /// Returns the title of the swipe action.
  String get title {
    switch (this) {
      case disabled:
        return l.action_disabled;
      case restore:
        return l.action_restore;
      case permanentlyDelete:
        return l.action_delete_permanently;
    }
  }
}
