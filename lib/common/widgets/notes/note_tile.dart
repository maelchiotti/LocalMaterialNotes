import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../../models/note/note.dart';
import '../../../models/note/note_status.dart';
import '../../../navigation/navigation_routes.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../../providers/preferences/preferences_provider.dart';
import '../../actions/notes/select.dart';
import '../../constants/paddings.dart';
import '../../constants/sizes.dart';
import '../../enums/swipe_direction.dart';
import '../../extensions/color_extension.dart';
import '../../preferences/enums/layout.dart';
import '../../preferences/enums/swipe_actions/archived_swipe_action.dart';
import '../../preferences/enums/swipe_actions/available_swipe_action.dart';
import '../../preferences/enums/swipe_actions/deleted_swipe_action.dart';
import '../../preferences/preference_key.dart';
import '../../types.dart';
import 'dismissible/archived_dismissible.dart';
import 'dismissible/available_dismissible.dart';
import 'dismissible/deleted_dismissible.dart';
import 'note_tile_labels_list.dart';

/// List tile that displays the main info about a note.
///
/// A custom `ListTile` widget is created because the default one doesn't allow not displaying a title.
class NoteTile extends ConsumerStatefulWidget {
  /// Note tile shown in the notes list or the bin.
  const NoteTile({super.key, required this.note, this.search});

  /// Note to display.
  final Note note;

  /// Search text if this tile is shown in the search view.
  final String? search;

  @override
  ConsumerState<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends ConsumerState<NoteTile> {
  /// Returns the background color of the note tile.
  ///
  /// The background color depends on:
  ///   - Whether the tile is shown in the search view.
  ///   - Whether the note is selected.
  ///   - Whether the [showTilesBackground] setting is enabled.
  ///
  /// If none are `true`, then `null` is returned.
  Color? getBackgroundColor(bool showTilesBackground) {
    if (widget.search != null) {
      return Theme.of(context).colorScheme.surfaceContainerHigh;
    } else if (widget.note.selected) {
      return Theme.of(context).colorScheme.secondaryContainer;
    } else if (showTilesBackground) {
      return Theme.of(context).colorScheme.surfaceContainerHigh;
    } else {
      return null;
    }
  }

  /// Returns the border radius of the note tile.
  ///
  /// The border radius depends on:
  ///   - Whether the layout is [Layout.grid].
  ///   - Whether the [showTilesBackground] setting is enabled.
  ///
  /// If neither are `true`, then [BorderRadius.zero] is returned.
  BorderRadius getBorderRadius(Layout layout, bool showTilesBackground) =>
      layout == Layout.grid || showTilesBackground ? BorderRadius.circular(16) : BorderRadius.zero;

  /// Returns the dismiss direction of the note tile for an available note
  /// depending on the [rightSwipeAction] and the [leftSwipeAction].
  DismissDirection getAvailableDismissDirection(
    AvailableSwipeAction rightSwipeAction,
    AvailableSwipeAction leftSwipeAction,
  ) {
    if (rightSwipeAction.isEnabled && leftSwipeAction.isEnabled) {
      return DismissDirection.horizontal;
    } else if (rightSwipeAction.isEnabled && leftSwipeAction.isDisabled) {
      return DismissDirection.startToEnd;
    } else if (leftSwipeAction.isEnabled && rightSwipeAction.isDisabled) {
      return DismissDirection.endToStart;
    } else {
      return DismissDirection.none;
    }
  }

  /// Returns the dismiss direction of the note tile for an archived note
  /// depending on the [rightSwipeAction] and the [leftSwipeAction].
  DismissDirection getArchivedDismissDirection(
    ArchivedSwipeAction rightSwipeAction,
    ArchivedSwipeAction leftSwipeAction,
  ) {
    if (rightSwipeAction.isEnabled && leftSwipeAction.isEnabled) {
      return DismissDirection.horizontal;
    } else if (rightSwipeAction.isEnabled && leftSwipeAction.isDisabled) {
      return DismissDirection.startToEnd;
    } else if (leftSwipeAction.isEnabled && rightSwipeAction.isDisabled) {
      return DismissDirection.endToStart;
    } else {
      return DismissDirection.none;
    }
  }

  /// Returns the dismiss direction of the note tile for a deleted note
  /// depending on the [rightSwipeAction] and the [leftSwipeAction].
  DismissDirection getDeletedDismissDirection(DeletedSwipeAction rightSwipeAction, DeletedSwipeAction leftSwipeAction) {
    if (rightSwipeAction.isEnabled && leftSwipeAction.isEnabled) {
      return DismissDirection.horizontal;
    } else if (rightSwipeAction.isEnabled && leftSwipeAction.isDisabled) {
      return DismissDirection.startToEnd;
    } else if (leftSwipeAction.isEnabled && rightSwipeAction.isDisabled) {
      return DismissDirection.endToStart;
    } else {
      return DismissDirection.none;
    }
  }

  /// Returns the result of the [rightSwipeAction] or the [leftSwipeAction]
  /// on an available note depending on the [direction].
  Future<bool> onAvailableDismissed(
    DismissDirection direction,
    AvailableSwipeAction rightSwipeAction,
    AvailableSwipeAction leftSwipeAction,
  ) async {
    return direction == DismissDirection.startToEnd
        ? await rightSwipeAction.execute(context, ref, widget.note)
        : await leftSwipeAction.execute(context, ref, widget.note);
  }

  /// Returns the result of the [rightSwipeAction] or the [leftSwipeAction]
  /// on an archived note depending on the [direction].
  Future<bool> onArchivedDismissed(
    DismissDirection direction,
    ArchivedSwipeAction rightSwipeAction,
    ArchivedSwipeAction leftSwipeAction,
  ) async {
    return direction == DismissDirection.startToEnd
        ? await rightSwipeAction.execute(context, ref, widget.note)
        : await leftSwipeAction.execute(context, ref, widget.note);
  }

  /// Returns the result of the [rightSwipeAction] or the [leftSwipeAction]
  /// on a deleted note depending on the [direction].
  Future<bool> onDeletedDismissed(
    DismissDirection direction,
    DeletedSwipeAction rightSwipeAction,
    DeletedSwipeAction leftSwipeAction,
  ) async {
    return direction == DismissDirection.startToEnd
        ? await rightSwipeAction.execute(context, ref, widget.note)
        : await leftSwipeAction.execute(context, ref, widget.note);
  }

  /// Opens the editor for this note or selects this note, depending on whether the selection mode is enabled or not.
  void onTap() {
    if (isNotesSelectionModeNotifier.value) {
      toggleSelectNote(ref, note: widget.note);
    } else {
      isEditModeNotifier.value = !PreferenceKey.openEditorReadingMode.preferenceOrDefault;
      currentNoteNotifier.value = widget.note;

      // If the note was opened from the search view, it needs to be closed
      if (widget.search != null) {
        Navigator.pop(context);
      }

      final lockNote = PreferenceKey.lockNote.preferenceOrDefault;
      if (lockNote) {
        lockNoteNotifier.value = widget.note.locked || widget.note.hasLockedLabel;
      }

      final EditorPageExtra extra = (readOnly: widget.note.deleted, isNewNote: false);
      context.pushNamed(NavigationRoute.editor.name, extra: extra);
    }
  }

  /// Enters the selection mode and selects this note.
  void onLongPress() {
    isNotesSelectionModeNotifier.value = true;

    toggleSelectNote(ref, note: widget.note);
  }

  @override
  Widget build(BuildContext context) {
    final showTitlesOnly = PreferenceKey.showTitlesOnly.preferenceOrDefault;
    final showTilesBackground = PreferenceKey.showTilesBackground.preferenceOrDefault;
    final showNoteTypeIcon = PreferenceKey.showNoteTypeIcon.preferenceOrDefault;
    final showTitlesOnlyDisableInSearchView = PreferenceKey.showTitlesOnlyDisableInSearchView.preferenceOrDefault;
    final disableSubduedNoteContentPreview = PreferenceKey.disableSubduedNoteContentPreview.preferenceOrDefault;
    final maximumContentPreviewLines = PreferenceKey.maximumContentPreviewLines.preferenceOrDefault;

    final enableLabels = PreferenceKey.enableLabels.preferenceOrDefault;
    final showLabelsListOnNoteTile = PreferenceKey.showLabelsListOnNoteTile.preferenceOrDefault;

    final lockNote = PreferenceKey.lockNote.preferenceOrDefault;

    final biggerTitles = PreferenceKey.biggerTitles.preferenceOrDefault;

    final layout = ref.watch(preferencesProvider.select((preferences) => preferences.layout));

    final showContent =
        // Do not show only the title and the preview content is not empty
        (!showTitlesOnly && !widget.note.isContentPreviewEmpty) ||
        // Show only the title and the title is not empty
        (showTitlesOnly && widget.note.isTitleEmpty) ||
        // In search view, do not show only the title and the preview content is not empty
        (widget.search != null && showTitlesOnlyDisableInSearchView && !widget.note.isContentPreviewEmpty);

    var titleStyle = biggerTitles ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.titleMedium;
    titleStyle ??= TextStyle();
    final titleStyleHighlighted = titleStyle.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w900,
    );

    final bodyMediumTextTheme = Theme.of(context).textTheme.bodyMedium;
    var contentStyle = bodyMediumTextTheme?.copyWith(
      color: disableSubduedNoteContentPreview ? null : bodyMediumTextTheme.color?.subdued,
    );
    contentStyle ??= TextStyle();
    final contentStyleHighlighted = contentStyle.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.bold,
    );

    // Wrap the custom tile with Material to fix the tile background color not updating in real time when the tile is selected and the view is scrolled
    // See https://github.com/flutter/flutter/issues/86584
    final tile = Material(
      child: Ink(
        color: getBackgroundColor(showTilesBackground),
        child: InkWell(
          onTap: onTap,
          onLongPress: widget.search != null ? null : onLongPress,
          child: Padding(
            padding: Paddings.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          if (!widget.note.isTitleEmpty)
                            widget.search != null
                                ? SubstringHighlight(
                                  text: widget.note.title,
                                  terms: widget.search?.split(' '),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textStyle: titleStyle,
                                  textStyleHighlight: titleStyleHighlighted,
                                )
                                : Text(
                                  widget.note.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      biggerTitles
                                          ? Theme.of(context).textTheme.titleLarge
                                          : Theme.of(context).textTheme.titleMedium,
                                ),
                          // Subtitle
                          if (showContent)
                            widget.search != null
                                ? SubstringHighlight(
                                  text: widget.note.contentPreview,
                                  terms: widget.search?.split(' '),
                                  maxLines: maximumContentPreviewLines,
                                  overflow: TextOverflow.ellipsis,
                                  textStyle: contentStyle,
                                  textStyleHighlight: contentStyleHighlighted,
                                )
                                : Text(
                                  widget.note.contentPreview,
                                  maxLines: maximumContentPreviewLines,
                                  overflow: TextOverflow.ellipsis,
                                  style: contentStyle,
                                ),

                          if (enableLabels && showLabelsListOnNoteTile) ...[
                            Gap(4),
                            NoteTileLabelsList(note: widget.note),
                          ],
                        ],
                      ),
                    ),
                    Gap(8),
                    Column(
                      children: [
                        if (showNoteTypeIcon) ...[Gap(2), Icon(widget.note.type.icon, size: Sizes.iconSmall.size)],
                        if (widget.note.pinned && !widget.note.deleted) ...[
                          Gap(2),
                          Icon(Icons.push_pin, size: Sizes.iconSmall.size),
                        ],
                        if (lockNote && widget.note.locked) ...[Gap(2), Icon(Icons.lock, size: Sizes.iconSmall.size)],
                      ],
                    ),
                    // Trailing
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // In search view, just return the plain tile, without the ClipRRect or the Dismissible widgets
    if (widget.search != null) {
      return tile;
    }

    // Build the dismissible widgets
    final DismissDirection dismissDirection;
    Widget? mainDismissibleWidget;
    Widget? secondaryDismissibleWidget;
    final ConfirmDismissCallback? confirmDismiss;

    switch (widget.note.status) {
      // Build the available dismissible widgets
      case NoteStatus.available:
        final availableSwipeActionsPreferences = (
          right: PreferenceKey.swipeRightAction.preferenceOrDefault,
          left: PreferenceKey.swipeLeftAction.preferenceOrDefault,
        );
        final availableSwipeActions = (
          right: AvailableSwipeAction.rightFromPreference(
            preference: availableSwipeActionsPreferences.right,
            note: widget.note,
          ),
          left: AvailableSwipeAction.leftFromPreference(
            preference: availableSwipeActionsPreferences.left,
            note: widget.note,
          ),
        );

        dismissDirection = getAvailableDismissDirection(availableSwipeActions.right, availableSwipeActions.left);
        switch (dismissDirection) {
          case DismissDirection.horizontal:
            mainDismissibleWidget = AvailableDismissible(
              key: UniqueKey(),
              swipeAction: availableSwipeActions.right,
              direction: SwipeDirection.right,
            );
            secondaryDismissibleWidget = AvailableDismissible(
              key: UniqueKey(),
              swipeAction: availableSwipeActions.left,
              direction: SwipeDirection.left,
            );
          case DismissDirection.startToEnd:
            mainDismissibleWidget = AvailableDismissible(
              swipeAction: availableSwipeActions.right,
              direction: SwipeDirection.right,
            );
          case DismissDirection.endToStart:
            mainDismissibleWidget = AvailableDismissible(
              swipeAction: availableSwipeActions.left,
              direction: SwipeDirection.left,
            );
          case DismissDirection.none:
            break;
          default:
            throw Exception(
              'Unexpected dismiss direction when building the available dismissible widgets: $dismissDirection',
            );
        }

        confirmDismiss =
            (DismissDirection direction) =>
                onAvailableDismissed(direction, availableSwipeActions.right, availableSwipeActions.left);

      // Build the archived dismissible widgets
      case NoteStatus.archived:
        final archivedSwipeActions = (
          right: ArchivedSwipeAction.rightFromPreference(),
          left: ArchivedSwipeAction.leftFromPreference(),
        );

        dismissDirection = getArchivedDismissDirection(archivedSwipeActions.right, archivedSwipeActions.left);
        switch (dismissDirection) {
          case DismissDirection.horizontal:
            mainDismissibleWidget = ArchivedDismissible(key: UniqueKey(), direction: SwipeDirection.right);
            secondaryDismissibleWidget = ArchivedDismissible(key: UniqueKey(), direction: SwipeDirection.left);
          case DismissDirection.startToEnd:
            mainDismissibleWidget = ArchivedDismissible(direction: SwipeDirection.right);
          case DismissDirection.endToStart:
            mainDismissibleWidget = ArchivedDismissible(direction: SwipeDirection.left);
          case DismissDirection.none:
            break;
          default:
            throw Exception(
              'Unexpected dismiss direction when building the archived dismissible widgets: $dismissDirection',
            );
        }

        confirmDismiss =
            (DismissDirection direction) =>
                onArchivedDismissed(direction, archivedSwipeActions.right, archivedSwipeActions.left);

      // Build the deleted dismissible widgets
      case NoteStatus.deleted:
        final deletedSwipeActions = (
          right: DeletedSwipeAction.rightFromPreference(),
          left: DeletedSwipeAction.leftFromPreference(),
        );

        dismissDirection = getDeletedDismissDirection(deletedSwipeActions.right, deletedSwipeActions.left);
        switch (dismissDirection) {
          case DismissDirection.horizontal:
            mainDismissibleWidget = DeletedDismissible(key: UniqueKey(), direction: SwipeDirection.right);
            secondaryDismissibleWidget = DeletedDismissible(key: UniqueKey(), direction: SwipeDirection.left);
          case DismissDirection.startToEnd:
            mainDismissibleWidget = DeletedDismissible(direction: SwipeDirection.right);
          case DismissDirection.endToStart:
            mainDismissibleWidget = DeletedDismissible(direction: SwipeDirection.left);
          case DismissDirection.none:
            break;
          default:
            throw Exception(
              'Unexpected dismiss direction when building the deleted dismissible widgets: $dismissDirection',
            );
        }

        confirmDismiss = (DismissDirection direction) {
          return onDeletedDismissed(direction, deletedSwipeActions.right, deletedSwipeActions.left);
        };
    }

    return ClipRRect(
      borderRadius: getBorderRadius(layout, showTilesBackground),
      child: Dismissible(
        key: Key(widget.note.id),
        direction: dismissDirection,
        background: mainDismissibleWidget,
        secondaryBackground: secondaryDismissibleWidget,
        confirmDismiss: confirmDismiss,
        child: tile,
      ),
    );
  }
}
