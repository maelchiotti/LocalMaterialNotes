import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/color_extension.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/labels/labels_list/labels_list_provider.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class LabelsSelectionDialog extends ConsumerStatefulWidget {
  const LabelsSelectionDialog({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  ConsumerState<LabelsSelectionDialog> createState() => _LabelsSelectionDialogState();
}

class _LabelsSelectionDialogState extends ConsumerState<LabelsSelectionDialog> {
  late final List<Label> labels;

  @override
  void initState() {
    super.initState();

    labels = ref.read(labelsListProvider).value ?? [];
    for (var label in labels) {
      label.selected = widget.note.labels.contains(label);
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
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;

    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
      title: Text('Select labels'),
      content: SingleChildScrollView(
        child: ListBody(
          children: labels.mapIndexed((index, label) {
            return CheckboxListTile(
              value: label.selected,
              secondary: VariedIcon.varied(
                label.pinned ? Icons.label_important : Icons.label,
                fill: 1.0,
                color: label.color,
              ),
              title: Text(
                label.name,
                style: label.visible
                    ? null
                    : bodyLarge?.copyWith(
                        color: bodyLarge.color?.subdued,
                      ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onChanged: (value) => onChanged(index, value),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => pop(canceled: true),
          child: Text(flutterL?.cancelButtonLabel ?? 'Cancel'),
        ),
        TextButton(
          onPressed: pop,
          child: Text(flutterL?.okButtonLabel ?? 'OK'),
        ),
      ],
    );
  }
}
