import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../navigation/navigator_utils.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../../providers/preferences/preferences_provider.dart';
import '../../actions/notes/copy.dart';
import '../../actions/notes/delete.dart';
import '../../actions/notes/pin.dart';
import '../../actions/notes/restore.dart';
import '../../actions/notes/select.dart';
import '../../actions/notes/share.dart';
import '../../constants/paddings.dart';
import '../../constants/sizes.dart';
import '../../enums/swipe_direction.dart';
import '../../extensions/color_extension.dart';
import '../../preferences/enums/bin_swipe_action.dart';
import '../../preferences/enums/layout.dart';
import '../../preferences/enums/note_swipe_action.dart';
import '../../preferences/preference_key.dart';
import 'note_tile_dismissible.dart';
import 'note_tile_dismissible_bin.dart';
import 'note_tile_labels_list.dart';

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
  BorderRadius getBorderRadius(Layout layout, bool showTilesBackground) =>
      layout == Layout.grid || showTilesBackground ? BorderRadius.circular(16) : BorderRadius.zero;

  /// Returns the [DismissDirection] of the note tile for a note deleted note, depending on the [rightSwipeAction]
  /// and the [leftSwipeAction].
  DismissDirection getNoteDismissDirection(NoteSwipeAction rightSwipeAction, NoteSwipeAction leftSwipeAction) {
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

  /// Returns the [DismissDirection] of the note tile for a deleted note, depending on the [rightSwipeAction]
  /// and the [leftSwipeAction].
  DismissDirection getBinDismissDirection(BinSwipeAction rightSwipeAction, BinSwipeAction leftSwipeAction) {
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
  /// depending on the [direction], for a not deleted note.
  ({Widget? main, Widget? secondary}) getNoteDismissibleWidgets(
    DismissDirection direction,
    NoteSwipeAction rightSwipeAction,
    NoteSwipeAction leftSwipeAction,
  ) {
    switch (direction) {
      case DismissDirection.none:
        return (main: null, secondary: null);
      case DismissDirection.horizontal:
        return (
          main: getNoteDismissibleWidget(rightSwipeAction, SwipeDirection.right),
          secondary: getNoteDismissibleWidget(leftSwipeAction, SwipeDirection.left)
        );
      case DismissDirection.startToEnd:
        return (main: getNoteDismissibleWidget(rightSwipeAction, SwipeDirection.right), secondary: null);
      case DismissDirection.endToStart:
        return (main: getNoteDismissibleWidget(leftSwipeAction, SwipeDirection.left), secondary: null);
      default:
        throw Exception('Unexpected dismiss direction while building dismissible widgets: $direction');
    }
  }

  /// Returns the main and the secondary dismissible widgets for the [rightSwipeAction] and the [leftSwipeAction],
  /// depending on the [direction], for a deleted note.
  ({Widget? main, Widget? secondary}) getBinDismissibleWidgets(
    DismissDirection direction,
    BinSwipeAction rightSwipeAction,
    BinSwipeAction leftSwipeAction,
  ) {
    switch (direction) {
      case DismissDirection.none:
        return (main: null, secondary: null);
      case DismissDirection.horizontal:
        return (
          main: getBinDismissibleWidget(rightSwipeAction, SwipeDirection.right),
          secondary: getBinDismissibleWidget(leftSwipeAction, SwipeDirection.left)
        );
      case DismissDirection.startToEnd:
        return (main: getBinDismissibleWidget(rightSwipeAction, SwipeDirection.right), secondary: null);
      case DismissDirection.endToStart:
        return (main: getBinDismissibleWidget(leftSwipeAction, SwipeDirection.left), secondary: null);
      default:
        throw Exception('Unexpected dismiss direction while building dismissible widgets: $direction');
    }
  }

  /// Returns the dismissible widget for the [swipeAction] in the [swipeDirection].
  Widget getNoteDismissibleWidget(NoteSwipeAction swipeAction, SwipeDirection swipeDirection) => NoteTileDismissible(
        swipeAction: swipeAction,
        swipeDirection: swipeDirection,
        alternative: widget.note.pinned,
      );

  /// Returns the dismissible widget for the [swipeAction] in the [swipeDirection].
  Widget getBinDismissibleWidget(BinSwipeAction swipeAction, SwipeDirection swipeDirection) => NoteTileDismissibleBin(
        swipeAction: swipeAction,
        swipeDirection: swipeDirection,
        alternative: widget.note.pinned,
      );

  /// Executes the [rightSwipeAction] or the [leftSwipeAction] depending on the [direction] that was swiped.
  Future<bool> onNoteDismissed(
    DismissDirection direction,
    NoteSwipeAction rightSwipeAction,
    NoteSwipeAction leftSwipeAction,
  ) {
    switch (direction) {
      case DismissDirection.startToEnd:
        return performNoteDismissAction(rightSwipeAction);
      case DismissDirection.endToStart:
        return performNoteDismissAction(leftSwipeAction);
      default:
        throw Exception('Unexpected dismiss direction after swiping on note tile: $direction');
    }
  }

  /// Executes the [rightSwipeAction] or the [leftSwipeAction] depending on the [direction] that was swiped.
  Future<bool> onBinDismissed(
    DismissDirection direction,
    BinSwipeAction rightSwipeAction,
    BinSwipeAction leftSwipeAction,
  ) {
    switch (direction) {
      case DismissDirection.startToEnd:
        return performBinDismissAction(rightSwipeAction);
      case DismissDirection.endToStart:
        return performBinDismissAction(leftSwipeAction);
      default:
        throw Exception('Unexpected dismiss direction after swiping on note tile: $direction');
    }
  }

  Future<bool> performNoteDismissAction(NoteSwipeAction swipeAction) async {
    switch (swipeAction) {
      case NoteSwipeAction.delete:
        return deleteNote(context, ref, widget.note);
      case NoteSwipeAction.togglePin:
        return togglePinNote(context, ref, widget.note);
      case NoteSwipeAction.share:
        await shareNote(widget.note);

        return false;
      case NoteSwipeAction.copy:
        await copyNote(widget.note);

        return false;
      default:
        throw Exception('Unexpected swipe action when swiping on note tile: $swipeAction');
    }
  }

  Future<bool> performBinDismissAction(BinSwipeAction swipeAction) async {
    switch (swipeAction) {
      case BinSwipeAction.restore:
        return await restoreNote(context, ref, widget.note);
      case BinSwipeAction.permanentlyDelete:
        return await permanentlyDeleteNote(context, ref, widget.note);
      default:
        throw Exception('Unexpected swipe action when swiping on deleted note tile: $swipeAction');
    }
  }

  /// Opens the editor for this note or selects this note, depending on whether the selection mode is enabled or not.
  void onTap() {
    if (isNotesSelectionModeNotifier.value) {
      toggleSelectNote(ref, widget.note);
    } else {
      currentNoteNotifier.value = widget.note;

      // If the note was opened from the search view, it needs to be closed
      if (widget.searchView) {
        Navigator.pop(context);
      }

      NavigatorUtils.pushNotesEditor(context, widget.note.deleted, false);
    }
  }

  /// Enters the selection mode and selects this note.
  void onLongPress() {
    isNotesSelectionModeNotifier.value = true;

    toggleSelectNote(ref, widget.note);
  }

  @override
  Widget build(BuildContext context) {
    final showTitlesOnly = ref.watch(preferencesProvider.select((preferences) => preferences.showTitlesOnly));
    final showTilesBackground = ref.watch(preferencesProvider.select((preferences) => preferences.showTilesBackground));
    final showTitlesOnlyDisableInSearchView = PreferenceKey.showTitlesOnlyDisableInSearchView.getPreferenceOrDefault();
    final disableSubduedNoteContentPreview =
        ref.watch(preferencesProvider.select((preferences) => preferences.disableSubduedNoteContentPreview));

    final swipeActions = ref.watch(preferencesProvider.select((preferences) => preferences.swipeActions));
    final binSwipeActions = ref.watch(preferencesProvider.select((preferences) => preferences.binSwipeActions));

    final enableLabels = PreferenceKey.enableLabels.getPreferenceOrDefault();
    final showLabelsListOnNoteTile = PreferenceKey.showLabelsListOnNoteTile.getPreferenceOrDefault();

    final biggerTitles = ref.watch(preferencesProvider.select((preferences) => preferences.biggerTitles));

    final layout = ref.watch(preferencesProvider.select((preferences) => preferences.layout));

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
    final tile = Material(
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
                              style: biggerTitles
                                  ? Theme.of(context).textTheme.titleLarge
                                  : Theme.of(context).textTheme.titleMedium,
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
                if (enableLabels && showLabelsListOnNoteTile) ...[
                  Padding(padding: Paddings.vertical(2.0)),
                  NoteTileLabelsList(note: widget.note),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    // In search view, just return the plain tile, without the ClipRRect or the Dismissible widgets
    if (widget.searchView) {
      return tile;
    }

    final rightSwipeAction = swipeActions.right;
    final leftSwipeAction = swipeActions.left;
    final binRightSwipeAction = binSwipeActions.right;
    final binLeftSwipeAction = binSwipeActions.left;

    final direction = getNoteDismissDirection(rightSwipeAction, leftSwipeAction);
    final dismissibleWidgets = widget.note.deleted
        ? getBinDismissibleWidgets(direction, binRightSwipeAction, binLeftSwipeAction)
        : getNoteDismissibleWidgets(direction, rightSwipeAction, leftSwipeAction);

    return ClipRRect(
      borderRadius: getBorderRadius(layout, showTilesBackground),
      child: Dismissible(
        key: Key(widget.note.id.toString()),
        direction: direction,
        background: dismissibleWidgets.main,
        secondaryBackground: dismissibleWidgets.secondary,
        confirmDismiss: (dismissDirection) => widget.note.deleted
            ? onBinDismissed(dismissDirection, binRightSwipeAction, binLeftSwipeAction)
            : onNoteDismissed(dismissDirection, rightSwipeAction, leftSwipeAction),
        child: tile,
      ),
    );
  }
}
