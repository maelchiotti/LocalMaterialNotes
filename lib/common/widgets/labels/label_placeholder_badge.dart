import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/widgets/labels/label_badge.dart';

/// Placeholder badge for the labels.
class LabelPlaceholderBadge extends StatelessWidget {
  /// A badge similar to the [LabelBadge], but with a neutral color and a [text].
  const LabelPlaceholderBadge({
    super.key,
    required this.text,
  });

  /// The text to display in the badge.
  final String text;

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text(text),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      textColor: Theme.of(context).colorScheme.onSurface,
      padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
    );
  }
}
