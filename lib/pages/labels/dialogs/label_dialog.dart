import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/providers/labels/labels_list/labels_list_provider.dart';

class LabelDialog extends ConsumerStatefulWidget {
  const LabelDialog({
    super.key,
    required this.title,
    this.label,
  });

  final String title;
  final Label? label;

  @override
  ConsumerState<LabelDialog> createState() => _AddLabelDialogState();
}

class _AddLabelDialogState extends ConsumerState<LabelDialog> {
  final _formKey = GlobalKey<FormState>();

  late bool _ok;

  late final List<Label> _labels;

  /// Name of the label.
  late final TextEditingController _nameController;

  /// Color of the label.
  late Color _color;

  @override
  void initState() {
    super.initState();

    _ok = widget.label != null;
    _labels = ref.read(labelsListProvider).value!;

    _nameController = TextEditingController();
    if (widget.label != null) {
      _nameController.value = TextEditingValue(
        text: widget.label!.name,
        selection: TextSelection.collapsed(offset: widget.label!.name.length),
      );
    }
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    _color = widget.label?.color ?? Theme.of(context).colorScheme.tertiaryContainer;
  }

  String? _nameValidator(String? name) {
    if (name == null || name.isEmpty) {
      return 'The name cannot be empty.';
    } else if (_labels.map((label) => label.name).toList().contains(name) && name != widget.label?.name) {
      return 'This name is already used.';
    }

    return null;
  }

  void _onNameChanged(String? name) {
    setState(() {
      _ok = _formKey.currentState!.validate();
    });
  }

  Future<void> _pickColor() async {
    Color pickedColor = _color;

    final ok = await ColorPicker(
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
      _color = pickedColor;
    });
  }

  /// Pops the dialog with the entered [_nameController], or nothing if it was [canceled].
  void _pop({bool canceled = false}) {
    if (canceled) {
      Navigator.pop(context);

      return;
    }

    final label = widget.label != null
        ? (widget.label!
          ..name = _nameController.text
          ..colorHex = _color.value)
        : Label(name: _nameController.text, colorHex: _color.value);

    Navigator.pop(context, label);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              ColorIndicator(
                color: _color,
                height: Sizes.colorIndicator.size,
                width: Sizes.colorIndicator.size,
                borderRadius: Sizes.colorIndicator.size,
                onSelect: _pickColor,
              ),
              Padding(padding: Paddings.horizontal(8.0)),
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                  autofocus: true,
                  validator: _nameValidator,
                  onChanged: _onNameChanged,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _pop(canceled: true),
          child: Text(flutterL?.cancelButtonLabel ?? 'Cancel'),
        ),
        TextButton(
          onPressed: _ok ? _pop : null,
          child: Text(flutterL?.okButtonLabel ?? 'OK'),
        ),
      ],
    );
  }
}
