import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/preferences/preferences_provider.dart';
import '../../../constants/paddings.dart';
import '../../../enums/swipe_direction.dart';
import '../../../preferences/enums/swipe_actions/available_swipe_action.dart';

/// Available note tile dismissible widget.
class AvailableDismissible extends ConsumerStatefulWidget {
  /// Dismissible widget shown of the note tile of an available note.
  const AvailableDismissible({
    super.key,
    required this.direction,
    this.alternative = false,
  });

  /// Direction in which the widget can be swiped.
  final SwipeDirection direction;

  /// Whether the alternative text and icon should be used.
  final bool alternative;

  @override
  ConsumerState<AvailableDismissible> createState() => _AvailableDismissibleState();
}

class _AvailableDismissibleState extends ConsumerState<AvailableDismissible> {
  late final AvailableSwipeAction swipeAction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final swipeActions = ref.watch(
      preferencesProvider.select((preferences) => preferences.availableSwipeActions),
    );
    swipeAction = widget.direction == SwipeDirection.right ? swipeActions.right : swipeActions.left;
  }

  @override
  Widget build(BuildContext context) {
    final iconWidget = swipeAction.iconWidget(context, widget.alternative);
    final titleWidget = swipeAction.titleWidget(context, widget.alternative);

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
