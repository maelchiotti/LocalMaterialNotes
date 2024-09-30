import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/common/preferences/enums/swipe_direction.dart';

/// Dismissible widget for the delete swipe action.
class SwipeActionDismissible extends StatefulWidget {
  /// Default constructor.
  const SwipeActionDismissible({
    super.key,
    required this.swipeAction,
    required this.swipeDirection,
    this.alternative = false,
  });

  /// Swipe action to show.
  final SwipeAction swipeAction;

  /// Direction in which is widget will be swiped.
  final SwipeDirection swipeDirection;

  /// Whether the alternative text and icon should be used.
  final bool alternative;

  @override
  State<SwipeActionDismissible> createState() => _SwipeActionDismissibleState();
}

class _SwipeActionDismissibleState extends State<SwipeActionDismissible> {
  /// Whether the swipe action is dangerous.
  bool get dangerous {
    return widget.swipeAction.dangerous ?? false;
  }

  /// Icon of the swipe action to display.
  Widget get icon {
    return Icon(
      widget.alternative ? widget.swipeAction.alternativeIcon : widget.swipeAction.icon,
      color: dangerous
          ? Theme.of(context).colorScheme.onErrorContainer
          : Theme.of(context).colorScheme.onTertiaryContainer,
    );
  }

  /// Text of the swipe action to display.
  Widget get text {
    return Text(
      widget.swipeAction.title(widget.alternative),
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: dangerous
                ? Theme.of(context).colorScheme.onErrorContainer
                : Theme.of(context).colorScheme.onTertiaryContainer,
          ),
    );
  }

  /// Background color of the widget.
  Color get backgroundColor {
    return dangerous ? Theme.of(context).colorScheme.errorContainer : Theme.of(context).colorScheme.tertiaryContainer;
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding: Paddings.padding16.horizontal,
        child: Row(
          mainAxisAlignment:
              widget.swipeDirection == SwipeDirection.right ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (widget.swipeDirection == SwipeDirection.right) icon else text,
            Padding(padding: Paddings.padding4.horizontal),
            if (widget.swipeDirection == SwipeDirection.right) text else icon,
          ],
        ),
      ),
    );
  }
}
