import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class EditorToolbar extends ConsumerStatefulWidget {
  const EditorToolbar(this.fleatherController);

  final FleatherController fleatherController;

  @override
  ConsumerState<EditorToolbar> createState() => _EditorToolbarState();
}

class _EditorToolbarState extends ConsumerState<EditorToolbar> {
  Widget _buttonBuilder(
    BuildContext context,
    ParchmentAttribute attribute,
    IconData icon,
    bool isToggled,
    VoidCallback? onPressed,
  ) {
    return isToggled
        ? IconButton.filled(
            visualDensity: VisualDensity.compact,
            icon: Icon(icon),
            onPressed: onPressed,
          )
        : IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(icon),
            onPressed: onPressed,
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
    final buttons = [
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
      /* TODO Add the link button
       * Right now it requires to copy too much code
       * See https://github.com/fleather-editor/fleather/issues/353
      IconButton(
        visualDensity: VisualDensity.compact,
        icon: const Icon(Icons.link),
        onPressed: () => {},
      ),
       */
      IconButton(
        visualDensity: VisualDensity.compact,
        icon: const Icon(Icons.horizontal_rule),
        onPressed: _insertRule,
      ),
    ];

    return SizedBox(
      height: Sizes.custom.editorToolbarHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: Paddings.padding4.vertical.add(Paddings.padding4.horizontal),
        itemCount: buttons.length,
        itemBuilder: (BuildContext context, int index) {
          return buttons[index];
        },
        separatorBuilder: (context, index) {
          return Padding(padding: Paddings.padding2.horizontal);
        },
      ),
    );
  }
}
