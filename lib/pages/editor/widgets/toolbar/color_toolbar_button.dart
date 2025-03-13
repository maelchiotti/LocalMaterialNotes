import 'package:fleather/fleather.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../common/constants/constants.dart';
import 'toolbar_button.dart';

/// Color toolbar button.
class ColorToolbarButton extends StatefulWidget {
  /// Rich text editor toolbar button to pick the foreground or background color.
  const ColorToolbarButton({
    super.key,
    required this.fleatherController,
    required this.attributeKey,
    required this.icon,
    required this.dialogTitle,
  });

  /// The fleather editor controller.
  final FleatherController fleatherController;

  /// The attribute key for the foreground or the background color.
  final ColorParchmentAttributeBuilder attributeKey;

  /// The icon of the button.
  final IconData icon;

  /// The title of the dialog to pick a color.
  final String dialogTitle;

  @override
  State<ColorToolbarButton> createState() => _ColorToolbarButtonState();
}

class _ColorToolbarButtonState extends State<ColorToolbarButton> {
  /// The current foreground or background color.
  late Color color;

  /// The color picked by the user.
  Color? pickedColor;

  /// The style of the current text selection.
  ParchmentStyle get selectionStyle => widget.fleatherController.getSelectionStyle();

  @override
  void initState() {
    super.initState();

    didChangeEditingValue();

    widget.fleatherController.addListener(didChangeEditingValue);
  }

  @override
  void dispose() {
    widget.fleatherController.removeListener(didChangeEditingValue);

    super.dispose();
  }

  void didChangeEditingValue() {
    final selectionColor = selectionStyle.get(widget.attributeKey);

    setState(() {
      color = Color(selectionColor?.value ?? Colors.black.toARGB32());
    });
  }

  /// Asks the user to pick a color.
  Future<void> pickColor() async {
    final selected = await ColorPicker(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.dialogTitle, style: Theme.of(context).textTheme.headlineMedium),
          Gap(8),
          Text(l.rich_text_editor_toolbar_dialog_color_description, style: Theme.of(context).textTheme.labelMedium),
          Gap(16),
        ],
      ),
      pickersEnabled: {ColorPickerType.primary: true, ColorPickerType.accent: true, ColorPickerType.custom: true},
      color: color,
      onColorChanged: (color) {
        pickedColor = color;
      },
    ).showPickerDialog(context);

    if (selected) {
      setColor();
    }
  }

  /// Sets the new color.
  void setColor() {
    final attribute =
        pickedColor != null ? widget.attributeKey.withColor(pickedColor!.toARGB32()) : widget.attributeKey.unset;
    widget.fleatherController.formatSelection(attribute);
  }

  /// Resets the color to [null].
  void resetColor() {
    pickedColor = null;

    setColor();
  }

  @override
  Widget build(BuildContext context) {
    return ToolbarButton(
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, size: 20),
          Container(
            width: 20,
            height: 4,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
          ),
        ],
      ),
      onPressed: pickColor,
      onLongPress: resetColor,
    );
  }
}
