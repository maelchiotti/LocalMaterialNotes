import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../pages/labels/enums/labels_filter.dart';
import '../../../../providers/labels/labels/labels_provider.dart';
import '../../../../providers/notifiers/notifiers.dart';
import '../../../constants/sizes.dart';
import '../../../extensions/build_context_extension.dart';

/// Labels app bar.
class LabelsAppBar extends ConsumerStatefulWidget {
  /// App bar of the labels page.
  const LabelsAppBar({super.key});

  @override
  ConsumerState<LabelsAppBar> createState() => _LabelsAppBarState();
}

class _LabelsAppBarState extends ConsumerState<LabelsAppBar> {
  /// Called when the filter action is pressed.
  Future<void> onFilterPressed() async {
    await ref.read(labelsProvider.notifier).filter(LabelsFilter.all);

    labelsFiltersNotifier.value = !labelsFiltersNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.l.navigation_manage_labels_page),
      actions: [
        IconButton(
          onPressed: onFilterPressed,
          icon: ValueListenableBuilder(
            valueListenable: labelsFiltersNotifier,
            builder: (context, labelsFilters, child) {
              return Icon(labelsFilters ? Icons.filter_list_off : Icons.filter_list);
            },
          ),
        ),
        Gap(Sizes.appBarEnd.size),
      ],
    );
  }
}
