import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder()
      : icon = null,
        text = null;

  EmptyPlaceholder.notes()
      : icon = Icons.notes,
        text = localizations.placeholder_notes;

  EmptyPlaceholder.bin()
      : icon = Icons.delete_outline,
        text = localizations.placeholder_bin;

  final IconData? icon;
  final String? text;

  @override
  Widget build(BuildContext context) {
    if (icon == null || text == null) {
      return Container();
    }

    return Center(
      child: Padding(
        padding: Paddings.custom.page,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: Sizes.size64.size,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              Padding(padding: Paddings.padding16.vertical),
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
