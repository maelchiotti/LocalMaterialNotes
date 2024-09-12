import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

/// Toolbar for the content text field that enables advanced formatting options.
class EditorToolbar extends StatefulWidget {
  /// Default constructor.
  const EditorToolbar({
    super.key,
    required this.editorController,
  });

  /// Controller of the content text field.
  final FleatherController editorController;

  @override
  State<EditorToolbar> createState() => _EditorToolbarState();
}

class _EditorToolbarState extends State<EditorToolbar> {
  /// Builds a button of the toolbar.
  ///
  /// Overrides the default button style of fleather.
  Widget _buttonBuilder(
    BuildContext context,
    ParchmentAttribute attribute,
    IconData icon,
    bool isToggled,
    VoidCallback? onPressed,
  ) {
    return Padding(
      padding: Paddings.padding2.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: Sizes.custom.editorToolbarButtonHeight,
          height: Sizes.custom.editorToolbarButtonWidth,
        ),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          visualDensity: VisualDensity.compact,
          fillColor: isToggled ? Theme.of(context).colorScheme.secondary : null,
          elevation: 0,
          onPressed: onPressed,
          child: Icon(icon),
        ),
      ),
    );
  }

  /// Inserts a rule in the content.
  ///
  /// Copied from the fleather source code to allow using a custom button to insert rules.
  void _insertRule() {
    final index = widget.editorController.selection.baseOffset;
    final length = widget.editorController.selection.extentOffset - index;
    final newSelection = widget.editorController.selection.copyWith(
      baseOffset: index + 2,
      extentOffset: index + 2,
    );

    widget.editorController.replaceText(index, length, BlockEmbed.horizontalRule, selection: newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return FleatherToolbar(
      padding: EdgeInsets.zero,
      children: [
        Padding(padding: Paddings.padding2.horizontal),
        ToggleStyleButton(
          attribute: ParchmentAttribute.bold,
          icon: Icons.format_bold,
          controller: widget.editorController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.italic,
          icon: Icons.format_italic,
          controller: widget.editorController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.underline,
          icon: Icons.format_underline,
          controller: widget.editorController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.strikethrough,
          icon: Icons.format_strikethrough,
          controller: widget.editorController,
          childBuilder: _buttonBuilder,
        ),
        if (!PreferenceKey.showChecklistButton.getPreferenceOrDefault<bool>())
          ToggleStyleButton(
            attribute: ParchmentAttribute.block.checkList,
            icon: Icons.checklist,
            controller: widget.editorController,
            childBuilder: _buttonBuilder,
          ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.block.bulletList,
          icon: Icons.format_list_bulleted,
          controller: widget.editorController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.block.numberList,
          icon: Icons.format_list_numbered,
          controller: widget.editorController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.inlineCode,
          icon: Icons.code,
          controller: widget.editorController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.block.code,
          icon: Symbols.code_blocks,
          controller: widget.editorController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.block.quote,
          icon: Icons.format_quote,
          controller: widget.editorController,
          childBuilder: _buttonBuilder,
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.horizontal_rule),
          onPressed: _insertRule,
        ),
        Padding(padding: Paddings.padding2.horizontal),
      ],
    );
  }
}
