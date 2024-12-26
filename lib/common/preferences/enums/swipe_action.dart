import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../actions/notes/copy.dart';
import '../../actions/notes/delete.dart';
import '../../actions/notes/pin.dart';
import '../../actions/notes/share.dart';
import '../../constants/constants.dart';
import '../../extensions/iterable_extension.dart';
import '../preference_key.dart';

/// Action to trigger when swiping on a note tile of a not deleted note.
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
  bool get isEnabled => this != disabled;

  /// Returns whether the swipe action is disabled.
  bool get isDisabled => this == disabled;

  /// Returns the title of the swipe action.
  ///
  /// Returns the alternative title if [alternative] is set to `true`.
  String title(bool alternative) {
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

  /// Icon of the swipe action to display.
  Widget iconWidget(BuildContext context, bool alternative) {
    return Icon(
      alternative && alternativeIcon != null ? alternativeIcon : icon,
      color: dangerous
          ? Theme.of(context).colorScheme.onErrorContainer
          : Theme.of(context).colorScheme.onTertiaryContainer,
    );
  }

  /// Text of the swipe action to display.
  Widget titleWidget(BuildContext context, bool alternative) {
    return Text(
      title(alternative),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: dangerous
                ? Theme.of(context).colorScheme.onErrorContainer
                : Theme.of(context).colorScheme.onTertiaryContainer,
          ),
    );
  }

  /// Background color of the widget.
  Color backgroundColor(BuildContext context) {
    return dangerous ? Theme.of(context).colorScheme.errorContainer : Theme.of(context).colorScheme.tertiaryContainer;
  }

  /// Executes the action corresponding to this swipe action on the [note].
  Future<bool> execute(BuildContext context, WidgetRef ref, Note note) async {
    switch (this) {
      case delete:
        return deleteNote(context, ref, note);
      case togglePin:
        return togglePinNote(context, ref, note);
      case share:
        await shareNote(note);

        return false;
      case copy:
        await copyNote(note);

        return false;
      default:
        throw Exception('Unexpected swipe action when swiping on note tile: $this');
    }
  }
}
