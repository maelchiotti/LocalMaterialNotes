import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/actions/delete.dart';
import 'package:localmaterialnotes/common/actions/pin.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/radiuses.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/common/preferences/enums/layout.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_direction.dart';
import 'package:localmaterialnotes/common/routing/router.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/common/widgets/dismissible/dismissible_delete.dart';
import 'package:localmaterialnotes/common/widgets/dismissible/dismissible_pin.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// List tile that displays the main info about a note.
///
/// A custom `ListTile` widget is created because the default one doesn't allow not displaying a title.
class NoteTile extends ConsumerStatefulWidget {
  /// Note tile shown in the notes list or the bin.
  const NoteTile(this.note) : searchView = false;

  /// Note tile shown in the search view.
  const NoteTile.searchView(this.note) : searchView = true;

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
  Color? _backgroundColor(bool showTilesBackground) {
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
  BorderRadius _borderRadius(Layout layout, bool showTilesBackground) {
    return layout == Layout.grid || showTilesBackground ? Radiuses.radius16.circular : BorderRadius.zero;
  }

  /// Returns the [DismissDirection] of the note tile, depending on the [rightSwipeAction] and the [leftSwipeAction].
  ///
  /// There are 4 possible outputs:
  ///   - right and left : [DismissDirection.horizontal]
  ///   - right only : [DismissDirection.startToEnd]
  ///   - left only : [DismissDirection.endToStart]
  ///   - none : [DismissDirection.none]
  DismissDirection _dismissDirection(SwipeAction rightSwipeAction, SwipeAction leftSwipeAction) {
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

  /// Returns the main and the secondary dismissible widgets, depending on the [direction].
  ///
  /// There are 4 possible outputs:
  ///   - right and left : ([_rightDismissibleWidget], [_leftDismissibleWidget])
  ///   - right only : ([_rightDismissibleWidget], null)
  ///   - left only : ([_leftDismissibleWidget], null)
  ///   - none : (null, null)
  (Widget?, Widget?) _dismissibleWidgets(
    DismissDirection direction,
    SwipeAction rightSwipeAction,
    SwipeAction leftSwipeAction,
  ) {
    // If the note is deleted, the secondary swipe action is not available
    if (widget.note.deleted) {
      return (null, null);
    }

    switch (direction) {
      case DismissDirection.none:
        return (null, null);
      case DismissDirection.horizontal:
        return (_rightDismissibleWidget(rightSwipeAction), _leftDismissibleWidget(leftSwipeAction));
      case DismissDirection.startToEnd:
        return (_rightDismissibleWidget(rightSwipeAction), null);
      case DismissDirection.endToStart:
        return (_leftDismissibleWidget(leftSwipeAction), null);
      default:
        throw Exception('Unexpected dismiss direction while building dismissible widgets: $direction');
    }
  }

  /// Returns the right dismissible background widget, depending on the [rightSwipeAction].
  Widget _rightDismissibleWidget(SwipeAction rightSwipeAction) {
    switch (rightSwipeAction) {
      case SwipeAction.delete:
        return const DismissibleDelete(swipeDirection: SwipeDirection.right);
      case SwipeAction.pin:
        return DismissiblePin(note: widget.note, swipeDirection: SwipeDirection.right);
      default:
        throw Exception('Unexpected build of the right dismissible widget while it is disabled');
    }
  }

  /// Returns the left dismissible background widget, depending the [leftSwipeAction].
  Widget _leftDismissibleWidget(SwipeAction leftSwipeAction) {
    switch (leftSwipeAction) {
      case SwipeAction.delete:
        return const DismissibleDelete(swipeDirection: SwipeDirection.left);
      case SwipeAction.pin:
        return DismissiblePin(note: widget.note, swipeDirection: SwipeDirection.left);
      default:
        throw Exception('Unexpected build of the left dismissible widget while it is disabled');
    }
  }

  /// Enters the selection mode and selects this note.
  void _enterSelectionMode() {
    isSelectionModeNotifier.value = true;

    widget.note.deleted
        ? ref.read(binProvider.notifier).select(widget.note)
        : ref.read(notesProvider.notifier).select(widget.note);
  }

  /// Opens the editor for this note or selects this note, depending on whether the selection mode is enabled or not.
  void _openOrSelect() {
    if (isSelectionModeNotifier.value) {
      if (widget.note.deleted) {
        widget.note.selected
            ? ref.read(binProvider.notifier).unselect(widget.note)
            : ref.read(binProvider.notifier).select(widget.note);
      } else {
        widget.note.selected
            ? ref.read(notesProvider.notifier).unselect(widget.note)
            : ref.read(notesProvider.notifier).select(widget.note);
      }
    } else {
      currentNoteNotifier.value = widget.note;

      context.push(
        RouterRoute.editor.fullPath!,
        extra: EditorParameters.from({'readonly': widget.note.deleted, 'autofocus': false}),
      );

      // If the note was opened from the search view, it need to be closed.
      if (widget.searchView) {
        context.pop();
      }
    }
  }

  /// Executes the [rightSwipeAction] or the [leftSwipeAction] depending on the [direction] that has been swiped.
  Future<bool> _dismiss(DismissDirection direction, SwipeAction rightSwipeAction, SwipeAction leftSwipeAction) {
    switch (direction) {
      case DismissDirection.startToEnd:
        switch (rightSwipeAction) {
          case SwipeAction.delete:
            return deleteNote(context, ref, widget.note);
          case SwipeAction.pin:
            return togglePinNote(context, ref, widget.note);
          default:
            throw Exception('Unexpected right swipe action when swiping on note tile: $rightSwipeAction');
        }
      case DismissDirection.endToStart:
        switch (leftSwipeAction) {
          case SwipeAction.delete:
            return deleteNote(context, ref, widget.note);
          case SwipeAction.pin:
            return togglePinNote(context, ref, widget.note);
          default:
            throw Exception('Unexpected left swipe action when swiping on note tile: $rightSwipeAction');
        }
      default:
        throw Exception('Unexpected dismiss direction after swiping on note tile: $direction');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tile = ValueListenableBuilder(
      valueListenable: showTilesBackgroundNotifier,
      builder: (BuildContext context, showTilesBackground, Widget? child) {
        // Wrap the custom tile with Material to fix the tile background color not updating in real time when the tile is selected and the view is scrolled
        // See https://github.com/flutter/flutter/issues/86584
        return Material(
          child: Ink(
            color: _backgroundColor(showTilesBackground),
            child: InkWell(
              onTap: _openOrSelect,
              onLongPress: widget.searchView ? null : _enterSelectionMode,
              child: Padding(
                padding: Paddings.padding16.all,
                child: Row(
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
                          if (!widget.note.isContentEmpty && !widget.note.isContentPreviewEmpty)
                            Text(
                              widget.note.contentPreview,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(175),
                                  ),
                            ),
                        ],
                      ),
                    ),
                    // Trailing
                    if (widget.note.pinned && !widget.note.deleted) ...[
                      Padding(padding: Paddings.padding2.horizontal),
                      Icon(
                        Icons.push_pin,
                        size: Sizes.size16.size,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    // In search view, just return the plain tile, without the ClipRRect or the Dismissible widgets
    if (widget.searchView) {
      return tile;
    }

    return ValueListenableBuilder(
      valueListenable: layoutNotifier,
      builder: (BuildContext context, layout, Widget? child) {
        return ValueListenableBuilder(
          valueListenable: showTilesBackgroundNotifier,
          builder: (BuildContext context, showTilesBackground, Widget? child) {
            return ValueListenableBuilder(
              valueListenable: swipeActionsNotifier,
              builder: (BuildContext context, swipeActions, Widget? child) {
                final rightSwipeAction = swipeActions.$1;
                final leftSwipeAction = swipeActions.$2;

                final direction = _dismissDirection(rightSwipeAction, leftSwipeAction);

                final dismissibleWidgets = _dismissibleWidgets(direction, rightSwipeAction, leftSwipeAction);
                final dismissibleMainWidget = dismissibleWidgets.$1;
                final dismissibleSecondaryWidget = dismissibleWidgets.$2;

                return ClipRRect(
                  borderRadius: _borderRadius(layout, showTilesBackground),
                  child: Dismissible(
                    key: Key(widget.note.id.toString()),
                    direction: direction,
                    background: dismissibleMainWidget,
                    secondaryBackground: dismissibleSecondaryWidget,
                    confirmDismiss: (dismissDirection) => _dismiss(dismissDirection, rightSwipeAction, leftSwipeAction),
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
