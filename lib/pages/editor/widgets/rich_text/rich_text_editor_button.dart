import 'package:flutter/material.dart';

import '../../../../common/constants/paddings.dart';
import '../../../../common/constants/sizes.dart';

/// Rich text editor custom toolbar button.
class RichTextEditorButton extends StatelessWidget {
  /// Custom button for the toolbar of the rich text editor.
  const RichTextEditorButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
  });

  /// Icon of the button.
  final IconData icon;

  /// Color of the icon.
  ///
  /// Used to show the button as disabled.
  final Color? iconColor;

  /// Called when the button is pressed.
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.horizontal(2),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(
          width: Sizes.editorToolbarButtonHeight.size,
          height: Sizes.editorToolbarButtonWidth.size,
        ),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          visualDensity: VisualDensity.compact,
          elevation: 0,
          onPressed: onPressed,
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
