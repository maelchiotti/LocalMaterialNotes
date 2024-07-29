import 'package:flutter/material.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/preferences/enums/swipe_direction.dart';

class DismissiblePinWidget extends StatelessWidget {
  const DismissiblePinWidget({
    super.key,
    required this.note,
    required this.swipeDirection,
  });

  final Note note;
  final SwipeDirection swipeDirection;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blue,
      child: Padding(
        padding: Paddings.padding8.horizontal,
        child: Row(
          mainAxisAlignment: swipeDirection == SwipeDirection.right ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            Icon(note.pinned ? Icons.push_pin_outlined : Icons.push_pin),
            Padding(padding: Paddings.padding4.horizontal),
            Text(
              note.pinned ? localizations.dismiss_unpin : localizations.dismiss_pin,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
