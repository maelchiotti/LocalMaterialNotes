import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../common/constants/paddings.dart';
import '../../../../common/constants/sizes.dart';
import 'rich_text_editor_button.dart';
import 'rich_text_editor_link_button.dart';

/// Rich text editor toolbar.
class RichTextEditorToolbar extends StatelessWidget {
  /// Toolbar of the rich text editor.
  const RichTextEditorToolbar({super.key, required this.fleatherController});

  /// The controller of the Fleather text field.
  final FleatherController fleatherController;

  /// Builds a custom button of the toolbar.
  Widget buttonBuilder(
    BuildContext context,
    ParchmentAttribute attribute,
    IconData icon,
    bool isToggled,
    VoidCallback? onPressed,
  ) {
    return Padding(
      padding: Paddings.vertical(2),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: Sizes.editorToolbarButtonHeight.size,
          height: Sizes.editorToolbarButtonWidth.size,
        ),
        child: RawMaterialButton(
          shape: CircleBorder(
            side: isToggled ? BorderSide(color: Theme.of(context).colorScheme.primary) : BorderSide.none,
          ),
          visualDensity: VisualDensity.compact,
          fillColor: isToggled ? Theme.of(context).colorScheme.surfaceContainerHighest : null,
          elevation: 0,
          onPressed: onPressed,
          child: Icon(icon),
        ),
      ),
    );
  }

  /// Inserts a rule in the content.
  void insertRule(FleatherController fleatherController) {
    final index = fleatherController.selection.baseOffset;
    final length = fleatherController.selection.extentOffset - index;
    final newSelection = fleatherController.selection.copyWith(baseOffset: index + 2, extentOffset: index + 2);

    fleatherController.replaceText(index, length, BlockEmbed.horizontalRule, selection: newSelection);
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: SizedBox(
        height: Sizes.editorToolbarHeight.size,
        child: FleatherToolbar(
          padding: EdgeInsets.zero,
          children: [
            Gap(4),
            ToggleStyleButton(
              attribute: ParchmentAttribute.bold,
              icon: Icons.format_bold,
              controller: fleatherController,
              childBuilder: buttonBuilder,
            ),
            Gap(4),
            ToggleStyleButton(
              attribute: ParchmentAttribute.italic,
              icon: Icons.format_italic,
              controller: fleatherController,
              childBuilder: buttonBuilder,
            ),
            Gap(4),
            ToggleStyleButton(
              attribute: ParchmentAttribute.underline,
              icon: Icons.format_underline,
              controller: fleatherController,
              childBuilder: buttonBuilder,
            ),
            Gap(4),
            ToggleStyleButton(
              attribute: ParchmentAttribute.strikethrough,
              icon: Icons.format_strikethrough,
              controller: fleatherController,
              childBuilder: buttonBuilder,
            ),
            Gap(4),
            ToggleStyleButton(
              attribute: ParchmentAttribute.block.checkList,
              icon: Icons.checklist,
              controller: fleatherController,
              childBuilder: buttonBuilder,
            ),
            Gap(4),
            ToggleStyleButton(
              attribute: ParchmentAttribute.block.bulletList,
              icon: Icons.format_list_bulleted,
              controller: fleatherController,
              childBuilder: buttonBuilder,
            ),
            Gap(4),
            ToggleStyleButton(
              attribute: ParchmentAttribute.block.numberList,
              icon: Icons.format_list_numbered,
              controller: fleatherController,
              childBuilder: buttonBuilder,
            ),
            Gap(4),
            ToggleStyleButton(
              attribute: ParchmentAttribute.inlineCode,
              icon: Icons.code,
              controller: fleatherController,
              childBuilder: buttonBuilder,
            ),
            Gap(4),
            ToggleStyleButton(
              attribute: ParchmentAttribute.block.code,
              icon: Symbols.code_blocks,
              controller: fleatherController,
              childBuilder: buttonBuilder,
            ),
            Gap(4),
            ToggleStyleButton(
              attribute: ParchmentAttribute.block.quote,
              icon: Icons.format_quote,
              controller: fleatherController,
              childBuilder: buttonBuilder,
            ),
            Gap(4),
            RichTextEditorLinkButton(controller: fleatherController),
            Gap(4),
            RichTextEditorButton(icon: Icons.horizontal_rule, onPressed: () => insertRule(fleatherController)),
            Gap(4),
          ],
        ),
      ),
    );
  }
}
