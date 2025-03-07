import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/sizes.dart';
import '../../../common/extensions/color_extension.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../models/label/label.dart';
import '../../../models/note/note.dart';
import '../../../providers/labels/labels_list/labels_list_provider.dart';

/// Dialog to select the labels.
class LabelsSelectionDialog extends ConsumerStatefulWidget {
  /// A dialog allowing the user to select the labels of a note.
  const LabelsSelectionDialog({super.key, this.note});

  /// The note for which to select the labels.
  final Note? note;

  @override
  ConsumerState<LabelsSelectionDialog> createState() => _LabelsSelectionDialogState();
}

class _LabelsSelectionDialogState extends ConsumerState<LabelsSelectionDialog> {
  late final List<Label> labels;

  @override
  void initState() {
    super.initState();

    labels = ref.read(labelsListProvider).value ?? [];

    // Set the checkboxes to the selected state if the dialog is used to select the labels of a single note
    for (var label in labels) {
      label.selected = widget.note != null && widget.note!.labels.contains(label);
    }
  }

  void onChanged(int index, bool? value) {
    if (value == null) {
      return;
    }

    setState(() {
      labels[index].selected = value;
    });
  }

  /// Pops the dialog with the selected labels, or nothing if it was [canceled].
  void pop({bool canceled = false}) {
    if (canceled) {
      Navigator.pop(context);

      return;
    }

    final selectedLabels = labels.where((label) => label.selected).toList();

    Navigator.pop(context, selectedLabels);
  }

  @override
  Widget build(BuildContext context) {
    final lockLabel = PreferenceKey.lockLabel.preferenceOrDefault;

    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
      title: Text(widget.note == null ? l.dialog_select_labels_to_add : l.dialog_select_labels),
      content: SingleChildScrollView(
        child: ListBody(
          children:
              labels.mapIndexed((index, label) {
                return CheckboxListTile(
                  value: label.selected,
                  secondary: VariedIcon.varied(
                    label.pinned ? Icons.label_important : Icons.label,
                    fill: 1.0,
                    color: label.color,
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          label.name,
                          style: bodyLarge?.copyWith(color: !label.visible ? bodyLarge.color?.subdued : null),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (lockLabel && label.locked) Icon(Icons.lock, size: Sizes.iconSmall.size),
                    ],
                  ),
                  onChanged: (value) => onChanged(index, value),
                );
              }).toList(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => pop(canceled: true), child: Text(fl?.cancelButtonLabel ?? 'Cancel')),
        TextButton(onPressed: pop, child: Text(fl?.okButtonLabel ?? 'OK')),
      ],
    );
  }
}
