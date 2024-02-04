import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/back_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/back_menu_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/empty_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/search_sort_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/selection_app_bar.dart';
import 'package:localmaterialnotes/providers/selection_mode/selection_mode_provider.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';

enum TopNavigationStyle {
  empty,
  back,
  backMenu,
  searchSort,
}

class TopNavigation extends ConsumerWidget implements PreferredSizeWidget {
  const TopNavigation.empty() : topNavigationStyle = TopNavigationStyle.empty;

  const TopNavigation.back() : topNavigationStyle = TopNavigationStyle.back;

  const TopNavigation.backMenu() : topNavigationStyle = TopNavigationStyle.backMenu;

  const TopNavigation.searchSort({super.key}) : topNavigationStyle = TopNavigationStyle.searchSort;

  final TopNavigationStyle topNavigationStyle;

  @override
  Size get preferredSize {
    var height = kToolbarHeight;

    if (topNavigationStyle == TopNavigationStyle.searchSort) {
      height += Sizes.custom.searchAppBar;
    }

    return Size.fromHeight(height);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(selectionModeProvider)) {
      return const SelectionAppBar();
    }

    switch (topNavigationStyle) {
      case TopNavigationStyle.empty:
        return const EmptyAppBar();
      case TopNavigationStyle.back:
        return const BackAppBar();
      case TopNavigationStyle.backMenu:
        return const BackMenuAppBar();
      case TopNavigationStyle.searchSort:
        return SearchSortAppBar(key: super.key);
    }
  }
}
