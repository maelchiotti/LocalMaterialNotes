import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';

/// Placeholder widget for empty content.
class EmptyPlaceholder extends StatelessWidget {
  /// Default constructor.
  const EmptyPlaceholder({super.key, this.icon, this.text});

  /// Empty notes lists.
  EmptyPlaceholder.notes({super.key})
      : icon = Icons.notes,
        text = localizations.placeholder_notes;

  /// Empty bin.
  EmptyPlaceholder.bin({super.key})
      : icon = Icons.delete_outline,
        text = localizations.placeholder_bin;

  /// Icon to display.
  final IconData? icon;

  /// Text to display.
  final String? text;

  @override
  Widget build(BuildContext context) {
    if (icon == null || text == null) {
      return Container();
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
