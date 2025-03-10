import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../common/constants/constants.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../enums/labels_filter.dart';

/// Labels filters.
class LabelsFilters extends ConsumerStatefulWidget {
  /// Filters for the labels page.
  const LabelsFilters({super.key});

  @override
  ConsumerState<LabelsFilters> createState() => _LabelsFiltersState();
}

class _LabelsFiltersState extends ConsumerState<LabelsFilters> {
  var filter = LabelsFilter.all;

  /// Called when a filter is selected, with its [value] and whether it is [selected].
  Future<void> onFilterSelected(LabelsFilter value, bool selected) async {
    value = selected ? value : LabelsFilter.all;

    await ref.read(labelsProvider.notifier).filter(value);

    setState(() {
      filter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final labelLock = PreferenceKey.lockLabel.preferenceOrDefault;

    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Gap(8.0),
        ChoiceChip(
          label: Text(l.filter_labels_all),
          selected: filter == LabelsFilter.all,
          onSelected: (selected) => onFilterSelected(LabelsFilter.all, selected),
        ),
        Gap(8.0),
        ChoiceChip(
          label: Text(l.filter_labels_visible),
          selected: filter == LabelsFilter.visible,
          onSelected: (selected) => onFilterSelected(LabelsFilter.visible, selected),
        ),
        Gap(8.0),
        ChoiceChip(
          label: Text(l.filter_labels_hidden),
          selected: filter == LabelsFilter.hidden,
          onSelected: (selected) => onFilterSelected(LabelsFilter.hidden, selected),
        ),
        Gap(8.0),
        ChoiceChip(
          label: Text(l.filter_labels_pinned),
          selected: filter == LabelsFilter.pinned,
          onSelected: (selected) => onFilterSelected(LabelsFilter.pinned, selected),
        ),
        Gap(8.0),
        if (labelLock) ...[
          ChoiceChip(
            label: Text(l.filter_labels_locked),
            selected: filter == LabelsFilter.locked,
            onSelected: (selected) => onFilterSelected(LabelsFilter.locked, selected),
          ),
          Gap(8.0),
        ],
      ],
    );
  }
}
