import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/selection_app_bar.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// Top navigation with the app bar.
class TopNavigation extends StatelessWidget implements PreferredSizeWidget {
  /// Default constructor.
  const TopNavigation({
    super.key,
    required this.appbar,
  });

  /// App bar depending on the current route and whether the selection mode is enabled.
  final Widget appbar;

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isSelectionModeNotifier,
      builder: (context, isSelectionMode, child) {
        // If the selection mode is enabled, return the selection app bar
        return isSelectionMode ? const SelectionAppBar() : appbar;
      },
    );
  }
}
