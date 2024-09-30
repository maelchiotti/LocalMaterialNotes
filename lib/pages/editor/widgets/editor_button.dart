import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';

/// Custom toolbar button.
class EditorButton extends StatelessWidget {
  /// Default constructor.
  const EditorButton({
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
  final Function()? onPressed;

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
