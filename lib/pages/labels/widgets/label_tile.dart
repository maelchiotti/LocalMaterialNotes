import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/labels/select.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/extensions/color_extension.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/pages/labels/dialogs/label_dialog.dart';
import 'package:localmaterialnotes/pages/labels/widgets/label_menu_option.dart';
import 'package:localmaterialnotes/providers/labels/labels/labels_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class LabelTile extends ConsumerStatefulWidget {
  const LabelTile({
    super.key,
    required this.label,
  });

  /// Label to display.
  final Label label;

  @override
  ConsumerState<LabelTile> createState() => _LabelTileState();
}

class _LabelTileState extends ConsumerState<LabelTile> {
  Color? get getBackgroundColor {
    return widget.label.selected ? Theme.of(context).colorScheme.secondaryContainer : null;
  }

  Future<void> edit() async {
    final editedLabel = await showAdaptiveDialog<Label>(
      context: context,
      builder: (context) {
        return LabelDialog(
          title: l.dialog_label_edit,
          label: widget.label,
        );
      },
    );

    if (editedLabel == null) {
      return;
    }

    await ref.read(labelsProvider.notifier).edit(editedLabel);
  }

  Future<void> delete() async {
    await ref.read(labelsProvider.notifier).delete(widget.label);
  }

  Future<void> togglePin() async {
    await ref.read(labelsProvider.notifier).togglePin(widget.label);
  }

  Future<void> toggleVisible() async {
    await ref.read(labelsProvider.notifier).toggleVisible(widget.label);
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
        edit();
      case LabelMenuOption.delete:
        delete();
    }
  }

  /// Executes the swipe action depending on the [direction] that was swiped.
  Future<bool> onDismissed(DismissDirection direction) async {
    switch (direction) {
      case DismissDirection.startToEnd:
        await delete();
      case DismissDirection.endToStart:
        await edit();
      default:
        throw Exception('Unexpected dismiss direction after swiping on label tile: $direction');
    }

    return false;
  }

  /// Enters the selection mode and selects this tile.
  void enterSelectionMode() {
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
            onTap: () => toggleSelectLabel(ref, widget.label),
            onLongPress: enterSelectionMode,
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
                      onPressed: togglePin,
                      icon: Icon(widget.label.pinned ? Icons.push_pin_outlined : Icons.push_pin),
                    ),
                  if (!widget.label.pinned)
                    IconButton(
                      onPressed: toggleVisible,
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
