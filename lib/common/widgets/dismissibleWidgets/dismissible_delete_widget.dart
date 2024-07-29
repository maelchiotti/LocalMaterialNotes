import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/preferences/enums/swipe_direction.dart';

class DismissibleDeleteWidget extends StatelessWidget {
  const DismissibleDeleteWidget({
    super.key,
    required this.swipeDirection,
  });

  final SwipeDirection swipeDirection;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.red,
      child: Padding(
        padding: Paddings.padding8.horizontal,
        child: Row(
          mainAxisAlignment: swipeDirection == SwipeDirection.right ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            const Icon(Icons.delete),
            Padding(padding: Paddings.padding4.horizontal),
            Text(
              localizations.dismiss_delete,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
