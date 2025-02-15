import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/note/note.dart';
import '../../../actions/notes/archive.dart';
import '../../../actions/notes/copy.dart';
import '../../../actions/notes/delete.dart';
import '../../../actions/notes/pin.dart';
import '../../../actions/notes/share.dart';
import '../../../constants/constants.dart';
import '../../../extensions/iterable_extension.dart';
import '../../preference_key.dart';

/// Action to trigger when swiping on a note tile of an available note.
enum AvailableSwipeAction {
  /// The swipe action is disabled.
  disabled(Icons.hide_source),

  /// Copy the note to the clipboard.
  copy(Icons.copy),

  /// Share the note.
  share(Icons.share),

  /// Toggle the pin status of the note.
  togglePin(Icons.push_pin, alternativeIcon: Icons.push_pin_outlined),

  /// Archive the note.
  archive(Icons.archive),

  /// Delete the note.
  delete(Icons.delete),
  ;

  /// Icon of the swipe action.
  final IconData icon;

  /// Alternative icon of the swipe action if the action has two states.
  final IconData? alternativeIcon;

  /// The swipe action that should be performed on a note tile of an available note when swiped.
  ///
  /// A swipe action is represented by an [icon] and a [title]. If it has two states, it can have an [alternativeIcon].
  const AvailableSwipeAction(this.icon, {this.alternativeIcon});

  /// Returns the value of the right swipe action preference if set, or its default value otherwise.
  factory AvailableSwipeAction.rightFromPreference() {
    final swipeRightAction = AvailableSwipeAction.values.byNameOrNull(
      PreferenceKey.swipeRightAction.getPreference(),
    );

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.swipeRightAction.reset();

      return AvailableSwipeAction.values.byName(PreferenceKey.swipeRightAction.defaultValue);
    }

    return swipeRightAction;
  }

  /// Returns the value of the left swipe action preference if set, or its default value otherwise.
  factory AvailableSwipeAction.leftFromPreference() {
    final swipeRightAction = AvailableSwipeAction.values.byNameOrNull(
      PreferenceKey.swipeLeftAction.getPreference(),
    );

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.swipeLeftAction.reset();

      return AvailableSwipeAction.values.byName(PreferenceKey.swipeLeftAction.defaultValue);
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
      case copy:
        return flutterL?.copyButtonLabel ?? 'Copy';
      case share:
        return l.action_share;
      case togglePin:
        return alternative ? l.action_unpin : l.action_pin;
      case archive:
        return l.action_archive;
      case delete:
        return l.action_delete;
    }
  }

  /// Icon of the swipe action to display.
  Widget iconWidget(BuildContext context, bool alternative) {
    return Icon(
      alternative && alternativeIcon != null ? alternativeIcon : icon,
      color: Theme.of(context).colorScheme.onTertiaryContainer,
    );
  }

  /// Text of the swipe action to display.
  Widget titleWidget(BuildContext context, bool alternative) {
    return Text(
      title(alternative),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
    );
  }

  /// Executes the action corresponding to this swipe action on the [note].
  Future<bool> execute(BuildContext context, WidgetRef ref, Note note) async {
    switch (this) {
      case copy:
        await copyNote(note: note);
        return false;
      case share:
        await shareNote(note: note);
        return false;
      case togglePin:
        return await togglePinNote(context, ref, note: note);
      case archive:
        return await archiveNote(context, ref, note: note);
      case delete:
        return await deleteNote(context, ref, note: note);
      default:
        throw Exception('Unexpected swipe action when swiping on note tile: $this');
    }
  }
}
