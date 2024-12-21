import 'package:flutter/material.dart';
import '../../constants/paddings.dart';
import '../../preferences/enums/swipe_action.dart';
import '../../preferences/enums/swipe_direction.dart';

/// Dismissible widget for the note swipe actions.
class NoteTileDismissible extends StatefulWidget {
  /// Default constructor.
  const NoteTileDismissible({
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
  State<NoteTileDismissible> createState() => _NoteTileDismissibleState();
}

class _NoteTileDismissibleState extends State<NoteTileDismissible> {
  /// Icon of the swipe action to display.
  Widget get icon => Icon(
        widget.alternative && widget.swipeAction.alternativeIcon != null
            ? widget.swipeAction.alternativeIcon
            : widget.swipeAction.icon,
        color: widget.swipeAction.dangerous
            ? Theme.of(context).colorScheme.onErrorContainer
            : Theme.of(context).colorScheme.onTertiaryContainer,
      );

  /// Text of the swipe action to display.
  Widget get text => Text(
        widget.swipeAction.title(widget.alternative),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: widget.swipeAction.dangerous
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onTertiaryContainer,
            ),
      );

  /// Background color of the widget.
  Color get backgroundColor => widget.swipeAction.dangerous
      ? Theme.of(context).colorScheme.errorContainer
      : Theme.of(context).colorScheme.tertiaryContainer;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: backgroundColor,
        child: Padding(
          padding: Paddings.horizontal(16),
          child: Row(
            mainAxisAlignment:
                widget.swipeDirection == SwipeDirection.right ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              if (widget.swipeDirection == SwipeDirection.right) icon else text,
              Padding(padding: Paddings.horizontal(4)),
              if (widget.swipeDirection == SwipeDirection.right) text else icon,
            ],
          ),
        ),
      );
}
