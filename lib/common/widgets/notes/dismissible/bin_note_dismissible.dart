import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/preferences/preferences_provider.dart';
import '../../../constants/paddings.dart';
import '../../../enums/swipe_direction.dart';
import '../../../preferences/enums/bin_swipe_action.dart';

/// Note tile dismissible widget.
class BinNoteDismissible extends ConsumerStatefulWidget {
  /// Dismissible widget for the note tile in the bin.
  const BinNoteDismissible({
    super.key,
    required this.direction,
  });

  /// Direction in which the widget can be swiped.
  final SwipeDirection direction;

  @override
  ConsumerState<BinNoteDismissible> createState() => _NoteTileDismissibleBinState();
}

class _NoteTileDismissibleBinState extends ConsumerState<BinNoteDismissible> {
  late final BinSwipeAction swipeAction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final swipeActions = ref.watch(preferencesProvider.select((preferences) => preferences.binSwipeActions));
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
