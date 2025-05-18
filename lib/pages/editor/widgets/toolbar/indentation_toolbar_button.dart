import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';

import 'toolbar_button.dart';

/// Indentation toolbar button.
class IndentationToolbarButton extends StatefulWidget {
  /// Rich text editor toolbar button to decrease the indentation.
  const IndentationToolbarButton.decrease({super.key, required this.fleatherController})
    : increase = false,
      icon = Icons.format_indent_decrease;

  /// Rich text editor toolbar button to increase the indentation.
  const IndentationToolbarButton.increase({super.key, required this.fleatherController})
    : increase = true,
      icon = Icons.format_indent_increase;

  /// The fleather editor controller.
  final FleatherController fleatherController;

  /// The icon of the button.
  final IconData icon;

  /// Whether this button should increase the indentation.
  final bool increase;

  @override
  State<IndentationToolbarButton> createState() => _IndentationToolbarButtonState();
}

class _IndentationToolbarButtonState extends State<IndentationToolbarButton> {
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
    setState(() {});
  }

  /// Increases or decreases the indentation.
  void setIndentation() {
    final indentLevel = selectionStyle.get(ParchmentAttribute.indent)?.value ?? 0;

    if (indentLevel == 0 && !widget.increase) {
      return;
    }

    if (indentLevel == 1 && !widget.increase) {
      widget.fleatherController.formatSelection(ParchmentAttribute.indent.unset);
    } else {
      widget.fleatherController.formatSelection(
        ParchmentAttribute.indent.withLevel(indentLevel + (widget.increase ? 1 : -1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = !selectionStyle.containsSame(ParchmentAttribute.block.code);

    return ToolbarButton(icon: Icon(widget.icon), onPressed: enabled ? setIndentation : null);
  }
}
