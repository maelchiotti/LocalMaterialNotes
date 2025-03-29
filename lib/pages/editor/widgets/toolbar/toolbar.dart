import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../../common/constants/paddings.dart';
import '../../../../../common/constants/separators.dart';
import '../../../../../common/constants/sizes.dart';
import '../../../../common/extensions/build_context_extension.dart';
import '../../../../common/preferences/enums/toolbar_style.dart';
import 'color_toolbar_button.dart';
import 'heading_toolbar_button.dart';
import 'horizontal_rule_toolbar_button.dart';
import 'indentation_toolbar_button.dart';
import 'link_toolbar_button.dart';

/// Rich text editor toolbar.
class Toolbar extends StatefulWidget {
  /// Toolbar of the rich text editor.
  const Toolbar({super.key, required this.fleatherController});

  /// The controller of the Fleather text field.
  final FleatherController fleatherController;

  @override
  State<Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> with SingleTickerProviderStateMixin {
  /// Whether the first row of the toolbar is shown.
  late bool isFirstRow;

  /// Controller of the toolbar rows animations.
  late AnimationController controller;

  /// Animation of the toolbar rows.
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    isFirstRow = true;
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward()
          ..repeat(reverse: true);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

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

  /// Returns the button to toggle between the rows of the toolbar.
  Widget getToolbarRowsToggleButton(IconData icon) {
    return Material(
      key: UniqueKey(),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: InkWell(onTap: toggleToolbarRows, child: SizedBox(height: 48, width: 48, child: Icon(icon))),
    );
  }

  /// Toggles the rows of the toolbar.
  void toggleToolbarRows() {
    setState(() {
      isFirstRow = !isFirstRow;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bold = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.bold,
      icon: Icons.format_bold,
      childBuilder: buttonBuilder,
    );
    final italic = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.italic,
      icon: Icons.format_italic,
      childBuilder: buttonBuilder,
    );
    final underline = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.underline,
      icon: Icons.format_underline,
      childBuilder: buttonBuilder,
    );
    final strikethrough = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.strikethrough,
      icon: Icons.format_strikethrough,
      childBuilder: buttonBuilder,
    );

    final heading = HeadingToolbarButton(controller: widget.fleatherController);
    final foregroundColor = ColorToolbarButton(
      fleatherController: widget.fleatherController,
      attributeKey: ParchmentAttribute.foregroundColor,
      icon: Icons.text_fields,
      dialogTitle: context.l.rich_text_editor_toolbar_dialog_color_title_foreground,
    );
    final backgroundColor = ColorToolbarButton(
      fleatherController: widget.fleatherController,
      attributeKey: ParchmentAttribute.backgroundColor,
      icon: Symbols.colors,
      dialogTitle: context.l.rich_text_editor_toolbar_dialog_color_title_background,
    );

    final bulletList = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.block.bulletList,
      icon: Icons.format_list_bulleted,
      childBuilder: buttonBuilder,
    );
    final numberList = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.block.numberList,
      icon: Icons.format_list_numbered,
      childBuilder: buttonBuilder,
    );
    final checkList = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.block.checkList,
      icon: Icons.checklist,
      childBuilder: buttonBuilder,
    );

    final alignLeft = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.left,
      icon: Icons.format_align_left,
      childBuilder: buttonBuilder,
    );
    final alignCenter = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.center,
      icon: Icons.format_align_center,
      childBuilder: buttonBuilder,
    );
    final alignRight = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.right,
      icon: Icons.format_align_right,
      childBuilder: buttonBuilder,
    );
    final alignJustify = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.justify,
      icon: Icons.format_align_justify,
      childBuilder: buttonBuilder,
    );

    final indentationDecrease = IndentationToolbarButton.decrease(fleatherController: widget.fleatherController);
    final indentationIncrease = IndentationToolbarButton.increase(fleatherController: widget.fleatherController);

    final inlineCode = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.inlineCode,
      icon: Icons.code,
      childBuilder: buttonBuilder,
    );
    final blockCode = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.block.code,
      icon: Symbols.code_blocks,
      childBuilder: buttonBuilder,
    );
    final blockQuote = ToggleStyleButton(
      controller: widget.fleatherController,
      attribute: ParchmentAttribute.block.quote,
      icon: Icons.format_quote,
      childBuilder: buttonBuilder,
    );

    final link = LinkToolbarButton(controller: widget.fleatherController);
    final horizontalRule = HorizontalRuleToolbarButton(fleatherController: widget.fleatherController);

    final bigGap = Gap(4);
    final smallGap = Gap(2);
    final separator = [bigGap, Separator.vertical(indent: 8), bigGap];

    final toolbarStyle = ToolbarStyle.fromPreference();

    final firstRow = switch (toolbarStyle) {
      ToolbarStyle.oneRowSimple => [
        bigGap,
        bold,
        smallGap,
        italic,
        smallGap,
        underline,
        ...separator,
        bulletList,
        smallGap,
        numberList,
        smallGap,
        checkList,
        ...separator,
        link,
        bigGap,
      ],
      ToolbarStyle.oneRowAll => [
        bigGap,
        bold,
        smallGap,
        italic,
        smallGap,
        strikethrough,
        smallGap,
        underline,
        ...separator,
        heading,
        smallGap,
        foregroundColor,
        smallGap,
        backgroundColor,
        ...separator,
        bulletList,
        smallGap,
        numberList,
        smallGap,
        checkList,
        ...separator,
        alignLeft,
        smallGap,
        alignCenter,
        smallGap,
        alignRight,
        smallGap,
        alignJustify,
        ...separator,
        indentationDecrease,
        smallGap,
        indentationIncrease,
        ...separator,
        inlineCode,
        smallGap,
        blockCode,
        smallGap,
        blockQuote,
        ...separator,
        link,
        smallGap,
        horizontalRule,
        bigGap,
      ],
      ToolbarStyle.twoRowsStacked || ToolbarStyle.twoRowsToggleable => [
        bigGap,
        bold,
        smallGap,
        italic,
        smallGap,
        strikethrough,
        smallGap,
        underline,
        ...separator,
        heading,
        smallGap,
        foregroundColor,
        smallGap,
        backgroundColor,
        ...separator,
        bulletList,
        smallGap,
        numberList,
        smallGap,
        checkList,
        bigGap,
      ],
    };

    final secondRow = switch (toolbarStyle) {
      ToolbarStyle.oneRowSimple || ToolbarStyle.oneRowAll => <Widget>[],
      ToolbarStyle.twoRowsStacked || ToolbarStyle.twoRowsToggleable => [
        bigGap,
        alignLeft,
        smallGap,
        alignCenter,
        smallGap,
        alignRight,
        smallGap,
        alignJustify,
        ...separator,
        indentationDecrease,
        smallGap,
        indentationIncrease,
        ...separator,
        inlineCode,
        smallGap,
        blockCode,
        smallGap,
        blockQuote,
        ...separator,
        link,
        smallGap,
        horizontalRule,
        bigGap,
      ],
    };

    Widget toolbar = switch (toolbarStyle) {
      ToolbarStyle.oneRowSimple ||
      ToolbarStyle.oneRowAll => Center(child: FleatherToolbar(padding: EdgeInsets.zero, children: firstRow)),
      ToolbarStyle.twoRowsStacked => FleatherToolbar(
        padding: EdgeInsets.zero,
        children: [
          Column(
            children: [
              IntrinsicHeight(child: Row(children: firstRow)),
              IntrinsicHeight(child: Row(children: secondRow)),
            ],
          ),
        ],
      ),
      ToolbarStyle.twoRowsToggleable => Row(
        children: [
          Expanded(
            child: ClipRect(
              child: Stack(
                children: [
                  AnimatedSlide(
                    offset: isFirstRow ? Offset.zero : Offset(0, -1),
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: FleatherToolbar(padding: EdgeInsets.zero, children: firstRow),
                  ),
                  AnimatedSlide(
                    offset: isFirstRow ? Offset(0, 1) : Offset.zero,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: FleatherToolbar(padding: EdgeInsets.zero, children: secondRow),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child:
                isFirstRow
                    ? getToolbarRowsToggleButton(Icons.arrow_downward)
                    : getToolbarRowsToggleButton(Icons.arrow_upward),
          ),
        ],
      ),
    };

    final toolbarHeight = switch (toolbarStyle) {
      ToolbarStyle.oneRowSimple || ToolbarStyle.oneRowAll || ToolbarStyle.twoRowsToggleable => 48.0,
      ToolbarStyle.twoRowsStacked => 96.0,
    };

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: SizedBox(height: toolbarHeight, width: double.infinity, child: toolbar),
    );
  }
}
