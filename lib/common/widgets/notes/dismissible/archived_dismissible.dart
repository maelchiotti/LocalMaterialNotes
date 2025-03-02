import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/paddings.dart';
import '../../../enums/swipe_direction.dart';
import '../../../preferences/enums/swipe_actions/archived_swipe_action.dart';

/// Archived note tile dismissible widget.
class ArchivedDismissible extends ConsumerStatefulWidget {
  /// Dismissible widget shown of the note tile of an archived note.
  const ArchivedDismissible({
    super.key,
    required this.direction,
  });

  /// Direction in which the widget can be swiped.
  final SwipeDirection direction;

  @override
  ConsumerState<ArchivedDismissible> createState() => _ArchivedDismissibleState();
}

class _ArchivedDismissibleState extends ConsumerState<ArchivedDismissible> {
  late final ArchivedSwipeAction swipeAction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final swipeActions = (
      right: ArchivedSwipeAction.rightFromPreference(),
      left: ArchivedSwipeAction.leftFromPreference(),
    );
    swipeAction = widget.direction == SwipeDirection.right ? swipeActions.right : swipeActions.left;
  }

  @override
  Widget build(BuildContext context) {
    final iconWidget = swipeAction.iconWidget(context);
    final titleWidget = swipeAction.titleWidget(context);

    return ColoredBox(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      child: Padding(
        padding: Paddings.horizontal(16),
        child: Row(
          mainAxisAlignment: widget.direction == SwipeDirection.right ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (widget.direction == SwipeDirection.right) iconWidget else titleWidget,
            Padding(padding: Paddings.horizontal(4)),
            if (widget.direction == SwipeDirection.right) titleWidget else iconWidget,
          ],
        ),
      ),
    );
  }
}
