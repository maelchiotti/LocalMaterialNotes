import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/notes/copy.dart';
import 'package:localmaterialnotes/common/actions/notes/delete.dart';
import 'package:localmaterialnotes/common/actions/notes/pin.dart';
import 'package:localmaterialnotes/common/actions/notes/select.dart';
import 'package:localmaterialnotes/common/actions/notes/share.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/common/extensions/color_extension.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_direction.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/widgets/notes/note_tile_dismissible.dart';
import 'package:localmaterialnotes/common/widgets/notes/note_tile_labels_list.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_editor_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';

/// List tile that displays the main info about a note.
///
/// A custom `ListTile` widget is created because the default one doesn't allow not displaying a title.
class NoteTile extends ConsumerStatefulWidget {
  /// Note tile shown in the notes list or the bin.
  const NoteTile({
    super.key,
    required this.note,
  }) : searchView = false;

  /// Note tile shown in the search view.
  const NoteTile.searchView({
    super.key,
    required this.note,
  }) : searchView = true;

  /// Note to display.
  final Note note;

  /// Whether the note tile is shown in the search view.
  final bool searchView;

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
    if (widget.searchView) {
      return Theme.of(context).colorScheme.surfaceContainerHigh;
    } else if (widget.note.selected) {
      return Theme.of(context).colorScheme.secondaryContainer;
    } else if (showTilesBackground) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
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
  BorderRadius getBorderRadius(Layout layout, bool showTilesBackground) {
    return layout == Layout.grid || showTilesBackground ? BorderRadius.circular(16) : BorderRadius.zero;
  }

  /// Returns the [DismissDirection] of the note tile, depending on the [rightSwipeAction] and the [leftSwipeAction].
  ///
  /// There are 4 possible outputs:
  ///   - right and left : [DismissDirection.horizontal]
  ///   - right only : [DismissDirection.startToEnd]
  ///   - left only : [DismissDirection.endToStart]
  ///   - none : [DismissDirection.none]
  DismissDirection getDismissDirection(SwipeAction rightSwipeAction, SwipeAction leftSwipeAction) {
    // If the note is deleted, no swipe actions are available
    if (widget.note.deleted) {
      return DismissDirection.none;
    }

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

  /// Returns the main and the secondary dismissible widgets for the [rightSwipeAction] and the [leftSwipeAction],
  /// depending on the [direction].
  ({Widget? main, Widget? secondary}) getDismissibleWidgets(
    DismissDirection direction,
    SwipeAction rightSwipeAction,
    SwipeAction leftSwipeAction,
  ) {
    // If the note is deleted, the swipe actions are not available
    if (widget.note.deleted) {
      return (main: null, secondary: null);
    }

    switch (direction) {
      case DismissDirection.none:
        return (main: null, secondary: null);
      case DismissDirection.horizontal:
        return (
          main: getDismissibleWidget(rightSwipeAction, SwipeDirection.right),
          secondary: getDismissibleWidget(leftSwipeAction, SwipeDirection.left)
        );
      case DismissDirection.startToEnd:
        return (main: getDismissibleWidget(rightSwipeAction, SwipeDirection.right), secondary: null);
      case DismissDirection.endToStart:
        return (main: getDismissibleWidget(leftSwipeAction, SwipeDirection.left), secondary: null);
      default:
        throw Exception('Unexpected dismiss direction while building dismissible widgets: $direction');
    }
  }

  /// Returns the dismissible widget for the [swipeAction] in the [swipeDirection].
  Widget getDismissibleWidget(SwipeAction swipeAction, SwipeDirection swipeDirection) {
    return NoteTileDismissible(
      swipeAction: swipeAction,
      swipeDirection: swipeDirection,
      alternative: widget.note.pinned,
    );
  }

  /// Executes the [rightSwipeAction] or the [leftSwipeAction] depending on the [direction] that was swiped.
  Future<bool> onDismissed(DismissDirection direction, SwipeAction rightSwipeAction, SwipeAction leftSwipeAction) {
    switch (direction) {
      case DismissDirection.startToEnd:
        return performDismissAction(rightSwipeAction);
      case DismissDirection.endToStart:
        return performDismissAction(leftSwipeAction);
      default:
        throw Exception('Unexpected dismiss direction after swiping on note tile: $direction');
    }
  }

  Future<bool> performDismissAction(SwipeAction swipeAction) async {
    switch (swipeAction) {
      case SwipeAction.delete:
        return deleteNote(context, ref, widget.note);
      case SwipeAction.togglePin:
        return togglePinNote(context, ref, widget.note);
      case SwipeAction.share:
        await shareNote(widget.note);

        return false;
      case SwipeAction.copy:
        await copyNote(widget.note);

        return false;
      default:
        throw Exception('Unexpected swipe action when swiping on note tile: $swipeAction');
    }
  }

  /// Enters the selection mode and selects this note.
  void onLongPress() {
    isNotesSelectionModeNotifier.value = true;

    toggleSelectNote(ref, widget.note);
  }

  /// Opens the editor for this note or selects this note, depending on whether the selection mode is enabled or not.
  void onTap() {
    if (isNotesSelectionModeNotifier.value) {
      toggleSelectNote(ref, widget.note);
    } else {
      currentNoteNotifier.value = widget.note;

      NotesEditorRoute(readOnly: widget.note.deleted, autoFocus: false).push(context);

      // If the note was opened from the search view, it needs to be closed.
      if (widget.searchView) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final showTitlesOnlyDisableInSearchView =
        PreferenceKey.showTitlesOnlyDisableInSearchView.getPreferenceOrDefault<bool>();
    final disableSubduedNoteContentPreview =
        PreferenceKey.disableSubduedNoteContentPreview.getPreferenceOrDefault<bool>();
    final enableLabels = PreferenceKey.enableLabels.getPreferenceOrDefault<bool>();

    final tile = ValueListenableBuilder(
      valueListenable: showTitlesOnlyNotifier,
      builder: (context, showTitlesOnly, child) {
        return ValueListenableBuilder(
          valueListenable: showTilesBackgroundNotifier,
          builder: (context, showTilesBackground, child) {
            final bodyMediumTextTheme = Theme.of(context).textTheme.bodyMedium;

            final showTitle =
                // Do not show only the title and the preview content is not empty
                (!showTitlesOnly && !widget.note.isContentPreviewEmpty) ||
                    // Show only the title and the title is not empty
                    (showTitlesOnly && widget.note.isTitleEmpty) ||
                    // In search view, do not show only the title and the preview content is not empty
                    (widget.searchView && showTitlesOnlyDisableInSearchView && !widget.note.isContentPreviewEmpty);

            // Wrap the custom tile with Material to fix the tile background color not updating in real time when the tile is selected and the view is scrolled
            // See https://github.com/flutter/flutter/issues/86584
            return Material(
              child: Ink(
                color: getBackgroundColor(showTilesBackground),
                child: InkWell(
                  onTap: onTap,
                  onLongPress: widget.searchView ? null : onLongPress,
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
                                    Text(
                                      widget.note.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.titleMedium,
                                    ),
                                  // Subtitle
                                  if (showTitle)
                                    Text(
                                      widget.note.contentPreview,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: disableSubduedNoteContentPreview
                                          ? null
                                          : bodyMediumTextTheme?.copyWith(
                                              color: bodyMediumTextTheme.color?.subdued,
                                            ),
                                    ),
                                ],
                              ),
                            ),
                            // Trailing
                            if (widget.note.pinned && !widget.note.deleted) ...[
                              Padding(padding: Paddings.horizontal(2.0)),
                              Icon(
                                Icons.push_pin,
                                size: Sizes.pinIconSize.size,
                              ),
                            ],
                          ],
                        ),
                        if (enableLabels) ...[
                          Padding(padding: Paddings.vertical(2.0)),
                          NoteTileLabelsList(note: widget.note),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    // In search view, just return the plain tile, without the ClipRRect or the Dismissible widgets
    if (widget.searchView) {
      return tile;
    }

    return ValueListenableBuilder(
      valueListenable: layoutNotifier,
      builder: (context, layout, child) {
        return ValueListenableBuilder(
          valueListenable: showTilesBackgroundNotifier,
          builder: (context, showTilesBackground, child) {
            return ValueListenableBuilder(
              valueListenable: swipeActionsNotifier,
              builder: (context, swipeActions, child) {
                final rightSwipeAction = swipeActions.right;
                final leftSwipeAction = swipeActions.left;

                final direction = getDismissDirection(rightSwipeAction, leftSwipeAction);
                final dismissibleWidgets = getDismissibleWidgets(direction, rightSwipeAction, leftSwipeAction);

                return ClipRRect(
                  borderRadius: getBorderRadius(layout, showTilesBackground),
                  child: Dismissible(
                    key: Key(widget.note.id.toString()),
                    direction: direction,
                    background: dismissibleWidgets.main,
                    secondaryBackground: dismissibleWidgets.secondary,
                    confirmDismiss: (dismissDirection) =>
                        onDismissed(dismissDirection, rightSwipeAction, leftSwipeAction),
                    child: tile,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
