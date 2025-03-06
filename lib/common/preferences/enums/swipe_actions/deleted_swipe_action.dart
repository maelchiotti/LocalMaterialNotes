import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/note/note.dart';
import '../../../actions/notes/delete.dart';
import '../../../actions/notes/restore.dart';
import '../../../constants/constants.dart';
import '../../../extensions/iterable_extension.dart';
import '../../preference_key.dart';

/// Action to trigger when swiping on a note tile of a deleted note.
enum DeletedSwipeAction {
  /// The swipe action is disabled.
  disabled(Icons.hide_source),

  /// Restore the note.
  restore(Icons.restore_from_trash),

  /// Permanently delete the note.
  ///
  /// This action is [dangerous].
  permanentlyDelete(Icons.delete_forever, dangerous: true);

  /// Icon of the swipe action.
  final IconData icon;

  /// Whether the swipe action is a dangerous one.
  ///
  /// Changes the background, text and icon colors to red.
  final bool dangerous;

  /// The swipe action that should be performed on a note tile of a deleted note when swiped.
  ///
  /// A swipe action is represented by an [icon] and a [title].
  ///
  /// If it performs a dangerous action, is can be marked as [dangerous].
  const DeletedSwipeAction(this.icon, {this.dangerous = false});

  /// Returns the value of the right swipe action preference if set, or its default value otherwise.
  factory DeletedSwipeAction.rightFromPreference() {
    final swipeRightAction = DeletedSwipeAction.values.byNameOrNull(PreferenceKey.binSwipeRightAction.preference);

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.binSwipeRightAction.reset();

      return DeletedSwipeAction.values.byName(PreferenceKey.binSwipeRightAction.defaultValue);
    }

    return swipeRightAction;
  }

  /// Returns the value of the left swipe action preference if set, or its default value otherwise.
  factory DeletedSwipeAction.leftFromPreference() {
    final swipeRightAction = DeletedSwipeAction.values.byNameOrNull(PreferenceKey.binSwipeLeftAction.preference);

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.binSwipeLeftAction.reset();

      return DeletedSwipeAction.values.byName(PreferenceKey.binSwipeLeftAction.defaultValue);
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

  /// Icon of the swipe action to display.
  Widget iconWidget(BuildContext context) {
    return Icon(
      icon,
      color:
          dangerous
              ? Theme.of(context).colorScheme.onErrorContainer
              : Theme.of(context).colorScheme.onTertiaryContainer,
    );
  }

  /// Text of the swipe action to display.
  Widget titleWidget(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color:
            dangerous
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
      case restore:
        return await restoreNote(context, ref, note: note);
      case permanentlyDelete:
        return await permanentlyDeleteNote(context, ref, note: note);
      default:
        throw Exception('Unexpected swipe action when swiping on deleted note tile: $this');
    }
  }
}
