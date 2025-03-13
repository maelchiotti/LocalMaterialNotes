import 'package:flutter/material.dart';

import '../../../../../common/constants/paddings.dart';
import '../../../../../common/constants/sizes.dart';

/// Rich text editor custom toolbar button.
class ToolbarButton extends StatelessWidget {
  /// Custom button for the toolbar of the rich text editor.
  const ToolbarButton({super.key, required this.icon, this.onPressed, this.onLongPress});

  /// Icon of the button.
  final Widget icon;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Called when the button is long-pressed.
  final VoidCallback? onLongPress;

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
          onLongPress: onLongPress,
          child: icon,
        ),
      ),
    );
  }
}
