import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/preferences/preferences_provider.dart';
import '../../../constants/paddings.dart';
import '../../../enums/swipe_direction.dart';
import '../../../preferences/enums/swipe_action.dart';

/// Note tile dismissible widget.
class NoteDismissible extends ConsumerStatefulWidget {
  /// Dismissible widget for the note tile.
  const NoteDismissible({
    super.key,
    required this.direction,
    this.alternative = false,
  });

  /// Direction in which the widget can be swiped.
  final SwipeDirection direction;

  /// Whether the alternative text and icon should be used.
  final bool alternative;

  @override
  ConsumerState<NoteDismissible> createState() => _NoteDismissibleState();
}

class _NoteDismissibleState extends ConsumerState<NoteDismissible> {
  late final SwipeAction swipeAction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final swipeActions = ref.watch(preferencesProvider.select((preferences) => preferences.swipeActions));
    swipeAction = widget.direction == SwipeDirection.right ? swipeActions.right : swipeActions.left;
    print(swipeAction);
  }

  @override
  Widget build(BuildContext context) {
    final iconWidget = swipeAction.iconWidget(context, widget.alternative);
    final titleWidget = swipeAction.titleWidget(context, widget.alternative);

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
