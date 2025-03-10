import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/label/label.dart';
import '../../../actions/labels/delete.dart';
import '../../../actions/labels/edit.dart';
import '../../../actions/labels/lock.dart';
import '../../../actions/labels/pin.dart';
import '../../../actions/labels/visible.dart';
import '../../../constants/constants.dart';
import '../../../extensions/iterable_extension.dart';
import '../../preference_key.dart';

/// Label tile swipe action.
enum LabelSwipeAction {
  /// The swipe action is disabled.
  disabled(Icons.hide_source),

  /// Toggle whether the label is visible.
  ///
  /// Only used by the settings, then [show] or [hide] is used depending on the label.
  toggleVisible,

  /// Show the label.
  show(Icons.visibility),

  /// Hide the label.
  hide(Icons.visibility_off),

  /// Toggle whether the label is pinned.
  ///
  /// Only used by the settings, then [pin] or [unpin] is used depending on the label.
  togglePin(),

  /// Pin the label.
  pin(Icons.push_pin),

  /// Unpin the label.
  unpin(Icons.push_pin_outlined),

  /// Toggle whether the note is locked.
  ///
  /// Only used by the settings, then [lock] or [unlock] is used depending on the note.
  toggleLock,

  /// Lock the note.
  lock(Icons.lock),

  /// Unlock the note.
  unlock(Icons.lock_open),

  /// Archive the note.
  edit(Icons.edit),

  /// Delete the note.
  delete(Icons.delete);

  /// Icon of the swipe action.
  final IconData? icon;

  /// The swipe action that should be performed on a label tile when swiped.
  const LabelSwipeAction([this.icon]);

  /// Returns the value of the right swipe action [preference] if set, or its default value otherwise.
  ///
  /// If [label] is not `null`, it is used to determine which action to return if applicable.
  factory LabelSwipeAction.rightFromPreference({required String? preference, Label? label}) {
    var swipeRightAction = LabelSwipeAction.values.byNameOrNull(preference);

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.labelSwipeRightAction.reset();

      swipeRightAction = LabelSwipeAction.values.byName(PreferenceKey.labelSwipeRightAction.defaultValue);
    }

    // If the setting is to toggle the visibility, return the correct action
    if (label != null && swipeRightAction == toggleVisible) {
      return label.visible ? hide : show;
    }

    // If the setting is to toggle the pin, return the correct action
    if (label != null && swipeRightAction == togglePin) {
      return label.pinned ? unpin : pin;
    }

    // If the setting is to toggle the lock, return the correct action
    if (label != null && swipeRightAction == toggleLock) {
      final bool lockLabel = PreferenceKey.lockLabel.preferenceOrDefault;
      assert(lockLabel, "The right swipe action is 'Lock / Unlock' but the lock note setting is disabled");

      return label.locked ? unlock : lock;
    }

    return swipeRightAction;
  }

  /// Returns the value of the left swipe action [preference] if set, or its default value otherwise.
  ///
  /// If [label] is not `null`, it is used to determine which action to return if applicable.
  factory LabelSwipeAction.leftFromPreference({required String? preference, Label? label}) {
    var swipeLeftAction = LabelSwipeAction.values.byNameOrNull(PreferenceKey.labelSwipeLeftAction.preference);

    // Reset the malformed preference to its default value
    if (swipeLeftAction == null) {
      PreferenceKey.labelSwipeLeftAction.reset();

      swipeLeftAction = LabelSwipeAction.values.byName(PreferenceKey.labelSwipeLeftAction.defaultValue);
    }

    // If the setting is to toggle the visibility, return the correct action
    if (label != null && swipeLeftAction == toggleVisible) {
      return label.visible ? hide : show;
    }

    // If the setting is to toggle the pin, return the correct action
    if (label != null && swipeLeftAction == togglePin) {
      return label.pinned ? unpin : pin;
    }

    // If the setting is to toggle the lock, return the correct action
    if (label != null && swipeLeftAction == toggleLock) {
      final bool lockLabel = PreferenceKey.lockLabel.preferenceOrDefault;
      assert(lockLabel, "The left swipe action is 'Lock / Unlock' but the lock note setting is disabled");

      return label.locked ? unlock : lock;
    }

    return swipeLeftAction;
  }

  /// The swipe actions available to choose from in the settings.
  static List<LabelSwipeAction> get settings {
    final bool lockLabel = PreferenceKey.lockLabel.preferenceOrDefault;

    return [disabled, toggleVisible, togglePin, if (lockLabel) toggleLock, edit, delete];
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
      case toggleVisible:
        return l.action_labels_show_hide;
      case show:
        return l.action_labels_show;
      case hide:
        return l.action_labels_hide;
      case togglePin:
        return l.action_labels_pin_unpin;
      case pin:
        return l.action_labels_pin;
      case unpin:
        return l.action_labels_unpin;
      case toggleLock:
        return l.action_labels_lock_unlock;
      case lock:
        return l.action_labels_lock;
      case unlock:
        return l.action_labels_unlock;
      case edit:
        return l.action_labels_edit;
      case delete:
        return l.action_labels_delete;
    }
  }

  /// Icon of the swipe action to display.
  Widget iconWidget(BuildContext context) {
    return Icon(icon, color: Theme.of(context).colorScheme.onTertiaryContainer);
  }

  /// Text of the swipe action to display.
  Widget titleWidget(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer),
    );
  }

  /// Executes the action corresponding to this swipe action on the [label].
  Future<bool> execute(BuildContext context, WidgetRef ref, Label label) async {
    switch (this) {
      case show:
      case hide:
        await toggleVisibleLabels(ref, labels: [label]);
        return false;
      case pin:
      case unpin:
        await togglePinLabels(ref, labels: [label]);
        return false;
      case lock:
      case unlock:
        await toggleLockLabels(ref, labels: [label]);
        return false;
      case edit:
        await editLabel(context, ref, label: label);
        return false;
      case delete:
        return await deleteLabels(context, ref, labels: [label]);
      default:
        throw Exception('Unexpected swipe action when swiping on note tile: $this');
    }
  }
}
