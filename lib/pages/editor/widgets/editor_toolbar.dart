import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class EditorToolbar extends StatefulWidget {
  const EditorToolbar(this.fleatherController);

  final FleatherController fleatherController;

  @override
  State<EditorToolbar> createState() => _EditorToolbarState();
}

class _EditorToolbarState extends State<EditorToolbar> {
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

  void _insertRule() {
    final index = widget.fleatherController.selection.baseOffset;
    final length = widget.fleatherController.selection.extentOffset - index;
    final newSelection = widget.fleatherController.selection.copyWith(
      baseOffset: index + 2,
      extentOffset: index + 2,
    );

    widget.fleatherController.replaceText(index, length, BlockEmbed.horizontalRule, selection: newSelection);
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
          controller: widget.fleatherController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.italic,
          icon: Icons.format_italic,
          controller: widget.fleatherController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.underline,
          icon: Icons.format_underline,
          controller: widget.fleatherController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.strikethrough,
          icon: Icons.format_strikethrough,
          controller: widget.fleatherController,
          childBuilder: _buttonBuilder,
        ),
        if (!PreferenceKey.showChecklistButton.getPreferenceOrDefault<bool>())
          ToggleStyleButton(
            attribute: ParchmentAttribute.block.checkList,
            icon: Icons.checklist,
            controller: widget.fleatherController,
            childBuilder: _buttonBuilder,
          ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.block.bulletList,
          icon: Icons.format_list_bulleted,
          controller: widget.fleatherController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.block.numberList,
          icon: Icons.format_list_numbered,
          controller: widget.fleatherController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.inlineCode,
          icon: Icons.code,
          controller: widget.fleatherController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.block.code,
          icon: Symbols.code_blocks,
          controller: widget.fleatherController,
          childBuilder: _buttonBuilder,
        ),
        ToggleStyleButton(
          attribute: ParchmentAttribute.block.quote,
          icon: Icons.format_quote,
          controller: widget.fleatherController,
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
