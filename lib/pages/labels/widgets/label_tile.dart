import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../common/actions/labels/delete.dart';
import '../../../common/actions/labels/edit.dart';
import '../../../common/actions/labels/lock.dart';
import '../../../common/actions/labels/pin.dart';
import '../../../common/actions/labels/select.dart';
import '../../../common/actions/labels/visible.dart';
import '../../../common/constants/sizes.dart';
import '../../../common/enums/swipe_direction.dart';
import '../../../common/extensions/color_extension.dart';
import '../../../common/preferences/enums/swipe_actions/label_swipe_action.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/widgets/labels/label_dismissible.dart';
import '../../../models/label/label.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../enums/label_tile_menu_option.dart';

/// Tile of a label.
class LabelTile extends ConsumerStatefulWidget {
  /// A tile displaying all the information about the [label].
  const LabelTile({super.key, required this.label});

  /// The label to display.
  final Label label;

  @override
  ConsumerState<LabelTile> createState() => _LabelTileState();
}

class _LabelTileState extends ConsumerState<LabelTile> {
  Color? get getBackgroundColor => widget.label.selected ? Theme.of(context).colorScheme.secondaryContainer : null;

  /// Returns the dismiss direction of the label tile depending on the [rightSwipeAction] and the [leftSwipeAction].
  DismissDirection getDismissDirection(LabelSwipeAction rightSwipeAction, LabelSwipeAction leftSwipeAction) {
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

  Future<void> onMenuOptionSelected(LabelTileMenuOption labelMenuOption) async {
    switch (labelMenuOption) {
      case LabelTileMenuOption.show:
      case LabelTileMenuOption.hide:
        await toggleVisibleLabels(ref, labels: [widget.label]);
      case LabelTileMenuOption.pin:
      case LabelTileMenuOption.unpin:
        await togglePinLabels(ref, labels: [widget.label]);
      case LabelTileMenuOption.lock:
      case LabelTileMenuOption.unlock:
        await toggleLockLabels(ref, labels: [widget.label]);
      case LabelTileMenuOption.edit:
        await editLabel(context, ref, label: widget.label);
      case LabelTileMenuOption.delete:
        await deleteLabel(context, ref, label: widget.label);
    }
  }

  /// Returns the result of the [rightSwipeAction] or the [leftSwipeAction] on the label depending on the [direction].
  Future<bool> onDismissed(
    DismissDirection direction,
    LabelSwipeAction rightSwipeAction,
    LabelSwipeAction leftSwipeAction,
  ) async {
    return direction == DismissDirection.startToEnd
        ? await rightSwipeAction.execute(context, ref, widget.label)
        : await leftSwipeAction.execute(context, ref, widget.label);
  }

  /// Selects the label.
  void onTap() {
    toggleSelectLabel(ref, label: widget.label);
  }

  /// Enters the selection mode and selects this tile.
  void onLongPress() {
    isLabelsSelectionModeNotifier.value = true;

    toggleSelectLabel(ref, label: widget.label);
  }

  @override
  Widget build(BuildContext context) {
    final lockLabel = PreferenceKey.lockLabel.preferenceOrDefault;

    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    var icon = Icons.label;
    if (widget.label.pinned) {
      icon = Icons.label_important;
    } else if (widget.label.hidden) {
      icon = Icons.label_outline;
    }

    final labelSwipeActionsPreferences = (
      right: PreferenceKey.labelSwipeRightAction.preferenceOrDefault,
      left: PreferenceKey.labelSwipeLeftAction.preferenceOrDefault,
    );
    final labelSwipeActions = (
      right: LabelSwipeAction.rightFromPreference(preference: labelSwipeActionsPreferences.right, label: widget.label),
      left: LabelSwipeAction.leftFromPreference(preference: labelSwipeActionsPreferences.left, label: widget.label),
    );

    final dismissDirection = getDismissDirection(labelSwipeActions.right, labelSwipeActions.left);

    Widget? mainDismissibleWidget;
    Widget? secondaryDismissibleWidget;
    switch (dismissDirection) {
      case DismissDirection.horizontal:
        mainDismissibleWidget = LabelDismissible(
          key: UniqueKey(),
          swipeAction: labelSwipeActions.right,
          direction: SwipeDirection.right,
        );
        secondaryDismissibleWidget = LabelDismissible(
          key: UniqueKey(),
          swipeAction: labelSwipeActions.left,
          direction: SwipeDirection.left,
        );
      case DismissDirection.startToEnd:
        mainDismissibleWidget = LabelDismissible(swipeAction: labelSwipeActions.right, direction: SwipeDirection.right);
      case DismissDirection.endToStart:
        mainDismissibleWidget = LabelDismissible(swipeAction: labelSwipeActions.left, direction: SwipeDirection.left);
      case DismissDirection.none:
        break;
      default:
        throw Exception('Unexpected dismiss direction when building the label dismissible widgets: $dismissDirection');
    }

    confirmDismiss(DismissDirection direction) =>
        onDismissed(direction, labelSwipeActions.right, labelSwipeActions.left);

    // Wrap the custom tile with Material to fix the tile background color not updating in real time when the tile is selected and the view is scrolled
    // See https://github.com/flutter/flutter/issues/86584
    return Dismissible(
      key: Key(widget.label.name),
      direction: dismissDirection,
      background: mainDismissibleWidget,
      secondaryBackground: secondaryDismissibleWidget,
      confirmDismiss: confirmDismiss,
      child: Material(
        child: Ink(
          color: getBackgroundColor,
          child: InkWell(
            onTap: isLabelsSelectionModeNotifier.value ? onTap : null,
            onLongPress: onLongPress,
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 16.0, right: 8.0),
              leading: VariedIcon.varied(icon, fill: 1.0, color: widget.label.color),
              title: Text(
                widget.label.name,
                style: widget.label.visible ? null : bodyLarge?.copyWith(color: bodyLarge.color?.subdued),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (lockLabel && widget.label.locked) ...[Icon(Icons.lock, size: Sizes.iconSmall.size), Gap(2)],
                  PopupMenuButton<LabelTileMenuOption>(
                    itemBuilder: (context) {
                      return [
                        if (widget.label.pinned) LabelTileMenuOption.unpin.popupMenuItem(context),
                        if (!widget.label.pinned) LabelTileMenuOption.pin.popupMenuItem(context),
                        if (widget.label.visible) LabelTileMenuOption.hide.popupMenuItem(context),
                        if (!widget.label.visible) LabelTileMenuOption.show.popupMenuItem(context),
                        if (lockLabel && widget.label.locked) LabelTileMenuOption.unlock.popupMenuItem(context),
                        if (lockLabel && !widget.label.locked) LabelTileMenuOption.lock.popupMenuItem(context),
                        PopupMenuDivider(),
                        LabelTileMenuOption.edit.popupMenuItem(context),
                        LabelTileMenuOption.delete.popupMenuItem(context),
                      ];
                    },
                    onSelected: onMenuOptionSelected,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
