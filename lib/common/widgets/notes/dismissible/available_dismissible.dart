import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../constants/paddings.dart';
import '../../../enums/swipe_direction.dart';
import '../../../preferences/enums/swipe_actions/available_swipe_action.dart';

/// Available note tile dismissible widget.
class AvailableDismissible extends ConsumerStatefulWidget {
  /// Dismissible widget shown on the note tile of an available note.
  const AvailableDismissible({super.key, required this.swipeAction, required this.direction});

  /// The swipe action to display.
  final AvailableSwipeAction swipeAction;

  /// Direction in which the widget can be swiped.
  final SwipeDirection direction;

  @override
  ConsumerState<AvailableDismissible> createState() => _AvailableDismissibleState();
}

class _AvailableDismissibleState extends ConsumerState<AvailableDismissible> {
  @override
  Widget build(BuildContext context) {
    final iconWidget = widget.swipeAction.iconWidget(context);
    final titleWidget = widget.swipeAction.titleWidget(context);

    return ColoredBox(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: Paddings.horizontal(16),
        child: Row(
          mainAxisAlignment: widget.direction == SwipeDirection.right ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (widget.direction == SwipeDirection.right) iconWidget else titleWidget,
            Gap(8),
            if (widget.direction == SwipeDirection.right) titleWidget else iconWidget,
          ],
        ),
      ),
    );
  }
}
