import 'package:flutter/material.dart';
import '../../constants/constants.dart';
import '../../constants/paddings.dart';
import '../../constants/sizes.dart';

/// Placeholder.
class EmptyPlaceholder extends StatelessWidget {
  /// Placeholder widget for pages with an empty content (no notes, labels or empty bin).
  ///
  /// Displays a big icon and a short text indicating that the page is empty.
  const EmptyPlaceholder({super.key, this.icon, this.text});

  /// Empty notes lists.
  EmptyPlaceholder.notes({super.key})
      : icon = Icons.notes,
        text = l.placeholder_notes;

  /// Empty labels.
  EmptyPlaceholder.labels({super.key})
      : icon = Icons.label_outline,
        text = l.placeholder_labels;

  /// Empty bin.
  EmptyPlaceholder.bin({super.key})
      : icon = Icons.delete_outline,
        text = l.placeholder_bin;

  /// Icon to display.
  final IconData? icon;

  /// Text to display.
  final String? text;

  @override
  Widget build(BuildContext context) {
    if (icon == null || text == null) {
      return SizedBox.shrink();
    }

    return Center(
      child: Padding(
        padding: Paddings.page,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: Sizes.placeholderIcon.size,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              Padding(padding: Paddings.vertical(16)),
              Text(
                text!,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
