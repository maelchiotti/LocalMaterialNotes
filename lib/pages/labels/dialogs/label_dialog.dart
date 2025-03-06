import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/constants/sizes.dart';
import '../../../models/label/label.dart';
import '../../../providers/labels/labels_list/labels_list_provider.dart';

/// Dialog to add or edit a label.
class LabelDialog extends ConsumerStatefulWidget {
  /// A dialog allowing the user to add a label providing its name and color, or to edit an existing one.
  const LabelDialog({super.key, required this.title, this.label});

  /// The title of the dialog.
  final String title;

  /// The label to edit if the dialog is used to edit an existing label, `null` otherwise.
  final Label? label;

  @override
  ConsumerState<LabelDialog> createState() => _AddLabelDialogState();
}

class _AddLabelDialogState extends ConsumerState<LabelDialog> {
  final formKey = GlobalKey<FormState>();

  late bool ok;

  late final List<Label> labels;

  /// Name of the label.
  late final TextEditingController nameController;

  /// Color of the label.
  late Color color;

  @override
  void initState() {
    super.initState();

    ok = widget.label != null;
    labels = ref.read(labelsListProvider).value!;

    nameController = TextEditingController();
    if (widget.label != null) {
      nameController.value = TextEditingValue(
        text: widget.label!.name,
        selection: TextSelection.collapsed(offset: widget.label!.name.length),
      );
    }
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    color = widget.label?.color ?? Theme.of(context).colorScheme.tertiaryContainer;
  }

  String? nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return l.dialog_label_name_cannot_be_empty;
    } else if (labels.map((label) => label.name).toList().contains(name) && name != widget.label?.name) {
      return l.dialog_label_name_already_used;
    }

    return null;
  }

  void onNameChanged(String? name) {
    setState(() {
      ok = formKey.currentState!.validate();
    });
  }

  Future<void> pickColor() async {
    Color pickedColor = color;

    final ok = await ColorPicker(
      color: color,
      height: Sizes.colorIndicator.size,
      width: Sizes.colorIndicator.size,
      borderRadius: Sizes.colorIndicator.size,
      pickersEnabled: {
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      onColorChanged: (color) {
        pickedColor = color;
      },
    ).showPickerDialog(context);

    if (!ok) {
      return;
    }

    setState(() {
      color = pickedColor;
    });
  }

  /// Pops the dialog with the entered [nameController], or nothing if it was [canceled].
  void pop({bool canceled = false}) {
    if (canceled) {
      Navigator.pop(context);

      return;
    }

    final label =
        widget.label != null
            ? (widget.label!
              ..name = nameController.text
              ..colorHex = color.toARGB32())
            : Label(name: nameController.text, colorHex: color.toARGB32());

    Navigator.pop(context, label);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Row(
            children: [
              ColorIndicator(
                color: color,
                height: Sizes.colorIndicator.size,
                width: Sizes.colorIndicator.size,
                borderRadius: Sizes.colorIndicator.size,
                onSelect: pickColor,
              ),
              Padding(padding: Paddings.horizontal(8.0)),
              Expanded(
                child: TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(hintText: l.hint_label_name),
                  autofocus: true,
                  validator: nameValidator,
                  onChanged: onNameChanged,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => pop(canceled: true), child: Text(fl?.cancelButtonLabel ?? 'Cancel')),
        TextButton(onPressed: ok ? pop : null, child: Text(fl?.okButtonLabel ?? 'OK')),
      ],
    );
  }
}
