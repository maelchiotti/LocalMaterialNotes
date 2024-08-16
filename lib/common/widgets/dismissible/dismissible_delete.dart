import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_direction.dart';

/// Dismissible widget for the delete swipe action.
class DismissibleDelete extends StatelessWidget {
  const DismissibleDelete({
    super.key,
    required this.swipeDirection,
  });

  /// Direction in which is widget will be swiped.
  final SwipeDirection swipeDirection;

  @override
  Widget build(BuildContext context) {
    const icon = Icon(Icons.delete);
    final text = Text(
      localizations.dismiss_delete,
      style: Theme.of(context).textTheme.titleMedium,
    );

    return ColoredBox(
      color: Colors.red,
      child: Padding(
        padding: Paddings.padding16.horizontal,
        child: Row(
          mainAxisAlignment: swipeDirection == SwipeDirection.right ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (swipeDirection == SwipeDirection.right) icon else text,
            Padding(padding: Paddings.padding4.horizontal),
            if (swipeDirection == SwipeDirection.right) text else icon,
          ],
        ),
      ),
    );
  }
}
