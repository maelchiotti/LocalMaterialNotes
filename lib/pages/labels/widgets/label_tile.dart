import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/labels/delete.dart';
import 'package:localmaterialnotes/common/actions/labels/edit.dart';
import 'package:localmaterialnotes/common/actions/labels/pin.dart';
import 'package:localmaterialnotes/common/actions/labels/select.dart';
import 'package:localmaterialnotes/common/actions/labels/visible.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/extensions/color_extension.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/pages/labels/widgets/label_menu_option.dart';
import 'package:localmaterialnotes/providers/notifiers/notifiers.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

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
  Color? get getBackgroundColor {
    return widget.label.selected ? Theme.of(context).colorScheme.secondaryContainer : null;
  }

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

  Future<void> onMenuOptionSelected(LabelMenuOption labelMenuOption) async {
    switch (labelMenuOption) {
      case LabelMenuOption.edit:
        await editLabel(context, ref, widget.label);
      case LabelMenuOption.delete:
        await deleteLabel(context, ref, widget.label);
    }
  }

  /// Executes the swipe action depending on the [direction] that was swiped.
  Future<bool> onDismissed(DismissDirection direction) async {
    switch (direction) {
      case DismissDirection.startToEnd:
        await deleteLabel(context, ref, widget.label);
      case DismissDirection.endToStart:
        await editLabel(context, ref, widget.label);
      default:
        throw Exception('Unexpected dismiss direction after swiping on label tile: $direction');
    }

    return false;
  }

  /// Selects the label.
  void onTap() {
    toggleSelectLabel(ref, widget.label);
  }

  /// Enters the selection mode and selects this tile.
  void onLongPress() {
    isLabelsSelectionModeNotifier.value = true;

    toggleSelectLabel(ref, widget.label);
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

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
              leading: VariedIcon.varied(
                widget.label.pinned ? Icons.label_important : Icons.label,
                fill: 1.0,
                color: widget.label.color,
              ),
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
                      onPressed: () => togglePinLabel(context, ref, widget.label),
                      icon: Icon(widget.label.pinned ? Icons.push_pin_outlined : Icons.push_pin),
                    ),
                  if (!widget.label.pinned)
                    IconButton(
                      onPressed: () => toggleVisibleLabel(ref, widget.label),
                      icon: Icon(widget.label.visible ? Icons.visibility_off : Icons.visibility),
                    ),
                  PopupMenuButton<LabelMenuOption>(
                    itemBuilder: (context) {
                      return LabelMenuOption.values.map(
                        (labelMenuOption) {
                          return labelMenuOption.popupMenuItem(context);
                        },
                      ).toList();
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
