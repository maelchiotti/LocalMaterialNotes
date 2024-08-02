import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/selection_app_bar.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

class TopNavigation extends ConsumerWidget implements PreferredSizeWidget {
  const TopNavigation({super.key, required this.appbar});

  final Widget appbar;

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: isSelectionModeNotifier,
      builder: (BuildContext context, isSelectionMode, Widget? child) {
        // If the selection mode is enabled, return the selection app bar
        return isSelectionMode ? const SelectionAppBar() : appbar;
      },
    );
  }
}
