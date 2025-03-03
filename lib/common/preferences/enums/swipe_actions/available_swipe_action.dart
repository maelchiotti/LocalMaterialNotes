import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/note/note.dart';
import '../../../actions/notes/archive.dart';
import '../../../actions/notes/copy.dart';
import '../../../actions/notes/delete.dart';
import '../../../actions/notes/lock.dart';
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

  /// Toggle whether the note is pinned.
  ///
  /// Only used by the settings, then [pin] or [unpin] is used depending on the note.
  togglePin,

  /// Pin the note.
  pin(Icons.push_pin),

  /// Unpin the note.
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
  archive(Icons.archive),

  /// Delete the note.
  delete(Icons.delete),
  ;

  /// Icon of the swipe action.
  final IconData? icon;

  /// The swipe action that should be performed on a note tile of an available note when swiped.
  const AvailableSwipeAction([this.icon]);

  /// Returns the value of the right swipe action [preference] if set, or its default value otherwise.
  ///
  /// If [note] is not `null`, it is used to determine which action to return if applicable.
  factory AvailableSwipeAction.rightFromPreference({required String? preference, Note? note}) {
    var swipeRightAction = AvailableSwipeAction.values.byNameOrNull(preference);

    // Reset the malformed preference to its default value
    if (swipeRightAction == null) {
      PreferenceKey.swipeRightAction.reset();

      swipeRightAction = AvailableSwipeAction.values.byName(PreferenceKey.swipeRightAction.defaultValue);
    }

    // If the setting is to toggle the pin, return the correct action
    if (note != null && swipeRightAction == togglePin) {
      return note.pinned ? unpin : pin;
    }

    // If the setting is to toggle the lock, return the correct action
    if (note != null && swipeRightAction == toggleLock) {
      final bool lockNote = PreferenceKey.lockNote.preferenceOrDefault;
      assert(lockNote, "The right swipe action is 'Lock / Unlock' but the lock note setting is disabled");

      return note.locked ? unlock : lock;
    }

    return swipeRightAction;
  }

  /// Returns the value of the left swipe action [preference] if set, or its default value otherwise.
  ///
  /// If [note] is not `null`, it is used to determine which action to return if applicable.
  factory AvailableSwipeAction.leftFromPreference({required String? preference, Note? note}) {
    var swipeLeftAction = AvailableSwipeAction.values.byNameOrNull(
      PreferenceKey.swipeLeftAction.preference,
    );

    // Reset the malformed preference to its default value
    if (swipeLeftAction == null) {
      PreferenceKey.swipeLeftAction.reset();

      swipeLeftAction = AvailableSwipeAction.values.byName(PreferenceKey.swipeLeftAction.defaultValue);
    }

    // If the setting is to toggle the pin, return the correct action
    if (note != null && swipeLeftAction == togglePin) {
      return note.pinned ? unpin : pin;
    }

    // If the setting is to toggle the lock, return the correct action
    if (note != null && swipeLeftAction == toggleLock) {
      final bool lockNote = PreferenceKey.lockNote.preferenceOrDefault;
      assert(lockNote, "The left swipe action is 'Lock / Unlock' but the lock note setting is disabled");

      return note.locked ? unlock : lock;
    }

    return swipeLeftAction;
  }

  /// The swipe actions available to choose from in the settings.
  static List<AvailableSwipeAction> get settings {
    final bool lockNote = PreferenceKey.lockNote.preferenceOrDefault;

    return [
      disabled,
      copy,
      share,
      togglePin,
      if (lockNote) toggleLock,
      archive,
      delete,
    ];
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
      case copy:
        return fl?.copyButtonLabel ?? 'Copy';
      case share:
        return l.action_share;
      case togglePin:
        return l.action_pin_unpin;
      case pin:
        return l.action_pin;
      case unpin:
        return l.action_unpin;
      case toggleLock:
        return l.action_lock_unlock;
      case lock:
        return l.action_lock;
      case unlock:
        return l.action_unlock;
      case archive:
        return l.action_archive;
      case delete:
        return l.action_delete;
    }
  }

  /// Icon of the swipe action to display.
  Widget iconWidget(BuildContext context) {
    return Icon(
      icon,
      color: Theme.of(context).colorScheme.onTertiaryContainer,
    );
  }

  /// Text of the swipe action to display.
  Widget titleWidget(BuildContext context) {
    return Text(
      title,
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
      case pin:
      case unpin:
        await togglePinNotes(context, ref, notes: [note]);
        return false;
      case lock:
      case unlock:
        await toggleLockNotes(context, ref, notes: [note], requireAuthentication: true);
        return false;
      case archive:
        return await archiveNote(context, ref, note: note);
      case delete:
        return await deleteNote(context, ref, note: note);
      default:
        throw Exception('Unexpected swipe action when swiping on note tile: $this');
    }
  }
}
