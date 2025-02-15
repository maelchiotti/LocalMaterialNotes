import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../common/actions/labels/delete.dart';
import '../../../common/actions/labels/edit.dart';
import '../../../common/actions/labels/pin.dart';
import '../../../common/actions/labels/select.dart';
import '../../../common/actions/labels/visible.dart';
import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/extensions/color_extension.dart';
import '../../../models/label/label.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../enums/label_tile_menu_option.dart';

/// Tile of a label.
class LabelTile extends ConsumerStatefulWidget {
  /// A tile displaying all the information about the [label].
  const LabelTile({
    super.key,
    required this.label,
  });

  /// The label to display.
  final Label label;

  @override
  ConsumerState<LabelTile> createState() => _LabelTileState();
}

class _LabelTileState extends ConsumerState<LabelTile> {
  Color? get getBackgroundColor => widget.label.selected ? Theme.of(context).colorScheme.secondaryContainer : null;

  Widget get getDismissibleBackground {
    return ColoredBox(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: Paddings.horizontal(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
            Padding(padding: Paddings.horizontal(4)),
            Text(
              l.action_labels_delete,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get getDismissibleSecondaryBackground {
    return ColoredBox(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: Paddings.horizontal(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              l.action_labels_edit,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
            ),
            Padding(padding: Paddings.horizontal(4)),
            Icon(
              Icons.edit,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onMenuOptionSelected(LabelTileMenuOption labelMenuOption) async {
    switch (labelMenuOption) {
      case LabelTileMenuOption.edit:
        await editLabel(context, ref, label: widget.label);
      case LabelTileMenuOption.delete:
        await deleteLabel(context, ref, label: widget.label);
    }
  }

  /// Executes the swipe action depending on the [direction] that was swiped.
  Future<bool> onDismissed(DismissDirection direction) async {
    switch (direction) {
      case DismissDirection.startToEnd:
        await deleteLabel(context, ref, label: widget.label);
      case DismissDirection.endToStart:
        await editLabel(context, ref, label: widget.label);
      default:
        throw Exception('Unexpected dismiss direction after swiping on label tile: $direction');
    }

    return false;
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
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    var icon = Icons.label;
    if (widget.label.pinned) {
      icon = Icons.label_important;
    } else if (widget.label.hidden) {
      icon = Icons.label_outline;
    }

    // Wrap the custom tile with Material to fix the tile background color not updating in real time when the tile is selected and the view is scrolled
    // See https://github.com/flutter/flutter/issues/86584
    return Dismissible(
      key: Key(widget.label.name),
      background: getDismissibleBackground,
      secondaryBackground: getDismissibleSecondaryBackground,
      confirmDismiss: onDismissed,
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
                style: widget.label.visible
                    ? null
                    : bodyLarge?.copyWith(
                        color: bodyLarge.color?.subdued,
                      ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.label.visible)
                    IconButton(
                      onPressed: () => togglePinLabel(context, ref, label: widget.label),
                      icon: Icon(widget.label.pinned ? Icons.push_pin_outlined : Icons.push_pin),
                    ),
                  if (!widget.label.pinned)
                    IconButton(
                      onPressed: () => toggleVisibleLabel(ref, label: widget.label),
                      icon: Icon(widget.label.visible ? Icons.visibility_off : Icons.visibility),
                    ),
                  PopupMenuButton<LabelTileMenuOption>(
                    itemBuilder: (context) => LabelTileMenuOption.values
                        .map((labelMenuOption) => labelMenuOption.popupMenuItem(context))
                        .toList(),
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
