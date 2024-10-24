import 'package:flutter/material.dart';

class LabelPlaceholderBadge extends StatelessWidget {
  const LabelPlaceholderBadge({
    super.key,
    required this.text,
  });

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
