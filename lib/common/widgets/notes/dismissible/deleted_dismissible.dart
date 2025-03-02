import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/paddings.dart';
import '../../../enums/swipe_direction.dart';
import '../../../preferences/enums/swipe_actions/deleted_swipe_action.dart';

/// Deleted note tile dismissible widget.
class DeletedDismissible extends ConsumerStatefulWidget {
  /// Dismissible widget shown of the note tile of a deleted note.
  const DeletedDismissible({
    super.key,
    required this.direction,
  });

  /// Direction in which the widget can be swiped.
  final SwipeDirection direction;

  @override
  ConsumerState<DeletedDismissible> createState() => _DeletedDismissibleState();
}

class _DeletedDismissibleState extends ConsumerState<DeletedDismissible> {
  late final DeletedSwipeAction swipeAction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final swipeActions = (
      right: DeletedSwipeAction.rightFromPreference(),
      left: DeletedSwipeAction.leftFromPreference(),
    );
    swipeAction = widget.direction == SwipeDirection.right ? swipeActions.right : swipeActions.left;
  }

  @override
  Widget build(BuildContext context) {
    final iconWidget = swipeAction.iconWidget(context);
    final titleWidget = swipeAction.titleWidget(context);

    return ColoredBox(
      color: swipeAction.backgroundColor(context),
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
