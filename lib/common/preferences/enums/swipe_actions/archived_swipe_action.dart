import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/note/note.dart';
import '../../../actions/notes/copy.dart';
import '../../../actions/notes/delete.dart';
import '../../../actions/notes/share.dart';
import '../../../actions/notes/unarchive.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../extensions/iterable_extension.dart';
import '../../preference_key.dart';

/// Action to trigger when swiping on a note tile of an archived note.
enum ArchivedSwipeAction {
  /// The swipe action is disabled.
  disabled(Icons.hide_source),

  /// Copy the note to the clipboard.
  copy(Icons.copy),

  /// Share the note.
  share(Icons.share),

  /// Unarchive the note.
  unarchive(Icons.unarchive),

  /// Delete the note.
  delete(Icons.delete);

  /// Icon of the swipe action.
  final IconData icon;

  /// The swipe action that should be performed on a note tile of an available note when swiped.
  ///
  /// A swipe action is represented by an [icon] and a [title].
  const ArchivedSwipeAction(this.icon);

  /// Returns the value of the right swipe action preference if set, or its default value otherwise.
  factory ArchivedSwipeAction.rightFromPreference() {
    final swipeRightAction = ArchivedSwipeAction.values.byNameOrNull(PreferenceKey.archivedSwipeRightAction.preference);

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.archivedSwipeRightAction.reset();

      return ArchivedSwipeAction.values.byName(PreferenceKey.archivedSwipeRightAction.defaultValue);
    }

    return swipeRightAction;
  }

  /// Returns the value of the left swipe action preference if set, or its default value otherwise.
  factory ArchivedSwipeAction.leftFromPreference() {
    final swipeRightAction = ArchivedSwipeAction.values.byNameOrNull(PreferenceKey.archivedSwipeLeftAction.preference);

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.archivedSwipeLeftAction.reset();

      return ArchivedSwipeAction.values.byName(PreferenceKey.archivedSwipeLeftAction.defaultValue);
    }

    return swipeRightAction;
  }

  /// Returns whether the swipe action is enabled.
  bool get isEnabled => this != disabled;

  /// Returns whether the swipe action is disabled.
  bool get isDisabled => this == disabled;

  /// Returns the title of the swipe action.
  String title(BuildContext context) {
    switch (this) {
      case disabled:
        return context.l.action_disabled;
      case copy:
        return context.fl.copyButtonLabel;
      case share:
        return context.l.action_share;
      case unarchive:
        return context.l.action_unarchive;
      case delete:
        return context.l.action_delete;
    }
  }

  /// Icon of the swipe action to display.
  Widget iconWidget(BuildContext context) {
    return Icon(icon, color: Theme.of(context).colorScheme.onTertiaryContainer);
  }

  /// Text of the swipe action to display.
  Widget titleWidget(BuildContext context) {
    return Text(
      title(context),
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onTertiaryContainer),
    );
  }

  /// Executes the action corresponding to this swipe action on the [note].
  Future<bool> execute(BuildContext context, WidgetRef ref, Note note) async {
    switch (this) {
      case copy:
        await copyNote(context, note: note);
        return false;
      case share:
        await shareNote(note: note);
        return false;
      case unarchive:
        return await unarchiveNote(context, ref, note: note);
      case delete:
        return await deleteNote(context, ref, note: note);
      default:
        throw Exception('Unexpected swipe action when swiping on note tile: $this');
    }
  }
}
