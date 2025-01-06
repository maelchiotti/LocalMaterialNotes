import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../navigation/navigator_utils.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../../providers/preferences/preferences_provider.dart';
import '../../actions/notes/select.dart';
import '../../constants/paddings.dart';
import '../../constants/sizes.dart';
import '../../enums/swipe_direction.dart';
import '../../extensions/color_extension.dart';
import '../../preferences/enums/bin_swipe_action.dart';
import '../../preferences/enums/layout.dart';
import '../../preferences/enums/swipe_action.dart';
import '../../preferences/preference_key.dart';
import 'dismissible/bin_note_dismissible.dart';
import 'dismissible/note_dismissible.dart';
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

  /// Returns the dismiss direction of the note tile depending on the [rightSwipeAction] and the [leftSwipeAction].
  DismissDirection notesDismissDirection(SwipeAction rightSwipeAction, SwipeAction leftSwipeAction) {
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

  /// Returns the dismiss direction of the deleted note tile depending on the [rightSwipeAction] and the [leftSwipeAction].
  DismissDirection binDismissDirection(BinSwipeAction rightSwipeAction, BinSwipeAction leftSwipeAction) {
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

  /// Returns the result of the [rightSwipeAction] or the [leftSwipeAction] depending on the [direction].
  Future<bool> onNoteDismissed(
    DismissDirection direction,
    SwipeAction rightSwipeAction,
    SwipeAction leftSwipeAction,
  ) async {
    return direction == DismissDirection.startToEnd
        ? await rightSwipeAction.execute(context, ref, widget.note)
        : await leftSwipeAction.execute(context, ref, widget.note);
  }

  /// Returns the result of the [rightSwipeAction] or the [leftSwipeAction] depending on the [direction].
  Future<bool> onBinDismissed(
    DismissDirection direction,
    BinSwipeAction rightSwipeAction,
    BinSwipeAction leftSwipeAction,
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

    toggleSelectNote(ref, note: widget.note);
  }

  @override
  Widget build(BuildContext context) {
    final showTitlesOnly = ref.watch(preferencesProvider.select((preferences) => preferences.showTitlesOnly));
    final showTilesBackground = ref.watch(preferencesProvider.select((preferences) => preferences.showTilesBackground));
    final showTitlesOnlyDisableInSearchView = PreferenceKey.showTitlesOnlyDisableInSearchView.getPreferenceOrDefault();
    final disableSubduedNoteContentPreview =
        ref.watch(preferencesProvider.select((preferences) => preferences.disableSubduedNoteContentPreview));
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

    final notesSwipeActions = ref.watch(preferencesProvider.select((preferences) => preferences.swipeActions));
    final binSwipeActions = ref.watch(preferencesProvider.select((preferences) => preferences.binSwipeActions));

    final dismissDirection = widget.note.deleted
        ? binDismissDirection(binSwipeActions.right, binSwipeActions.left)
        : notesDismissDirection(notesSwipeActions.right, notesSwipeActions.left);

    Widget? mainDismissibleWidget;
    Widget? secondaryDismissibleWidget;
    if (widget.note.deleted) {
      switch (dismissDirection) {
        case DismissDirection.horizontal:
          mainDismissibleWidget = BinNoteDismissible(
            key: UniqueKey(),
            direction: SwipeDirection.right,
          );
          secondaryDismissibleWidget = BinNoteDismissible(
            key: UniqueKey(),
            direction: SwipeDirection.left,
          );
        case DismissDirection.startToEnd:
          mainDismissibleWidget = BinNoteDismissible(direction: SwipeDirection.right);
        case DismissDirection.endToStart:
          mainDismissibleWidget = BinNoteDismissible(direction: SwipeDirection.left);
        case DismissDirection.none:
          break;
        default:
          throw Exception('Unexpected dismiss direction when building the dismissible widgets: $dismissDirection');
      }
    } else {
      switch (dismissDirection) {
        case DismissDirection.horizontal:
          mainDismissibleWidget = NoteDismissible(
            key: UniqueKey(),
            direction: SwipeDirection.right,
            alternative: widget.note.pinned,
          );
          secondaryDismissibleWidget = NoteDismissible(
            key: UniqueKey(),
            direction: SwipeDirection.left,
            alternative: widget.note.pinned,
          );
        case DismissDirection.startToEnd:
          mainDismissibleWidget = NoteDismissible(direction: SwipeDirection.right, alternative: widget.note.pinned);
        case DismissDirection.endToStart:
          mainDismissibleWidget = NoteDismissible(direction: SwipeDirection.left, alternative: widget.note.pinned);
        case DismissDirection.none:
          break;
        default:
          throw Exception('Unexpected dismiss direction when building the dismissible widgets: $dismissDirection');
      }
    }

    return ClipRRect(
      borderRadius: getBorderRadius(layout, showTilesBackground),
      child: Dismissible(
        key: Key(widget.note.id.toString()),
        direction: dismissDirection,
        background: mainDismissibleWidget,
        secondaryBackground: secondaryDismissibleWidget,
        confirmDismiss: (direction) => widget.note.deleted
            ? onBinDismissed(direction, binSwipeActions.right, binSwipeActions.left)
            : onNoteDismissed(direction, notesSwipeActions.right, notesSwipeActions.left),
        child: tile,
      ),
    );
  }
}
