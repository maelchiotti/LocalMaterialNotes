import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../common/constants/constants.dart';
import '../enums/labels_filter.dart';
import '../../../providers/labels/labels/labels_provider.dart';

/// Filters for the labels.
class LabelsFilters extends ConsumerStatefulWidget {
  /// A list of filters for the labels list.
  ///
  /// Allows to filter the labels to show only:
  ///   - pinned labels
  ///   - hidden labels
  const LabelsFilters({super.key});

  @override
  ConsumerState<LabelsFilters> createState() => _LabelsFiltersState();
}

class _LabelsFiltersState extends ConsumerState<LabelsFilters> {
  LabelsFilter labelsFilter = LabelsFilter.all;

  Future<void> filter() async {
    await ref.read(labelsProvider.notifier).filter(labelsFilter);
  }

  void _changeFilter(LabelsFilter value, bool selected) {
    setState(() {
      labelsFilter = selected ? value : LabelsFilter.all;
    });

    filter();
  }

  @override
  Widget build(BuildContext context) => ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Gap(8.0),
          ChoiceChip(
            label: Text(l.filter_labels_all),
            selected: labelsFilter == LabelsFilter.all,
            onSelected: (selected) => _changeFilter(LabelsFilter.all, selected),
          ),
          Gap(8.0),
          ChoiceChip(
            label: Text(l.filter_labels_visible),
            selected: labelsFilter == LabelsFilter.visible,
            onSelected: (selected) => _changeFilter(LabelsFilter.visible, selected),
          ),
          Gap(8.0),
          ChoiceChip(
            label: Text(l.filter_labels_pinned),
            selected: labelsFilter == LabelsFilter.pinned,
            onSelected: (selected) => _changeFilter(LabelsFilter.pinned, selected),
          ),
          Gap(8.0),
          ChoiceChip(
            label: Text(l.filter_labels_hidden),
            selected: labelsFilter == LabelsFilter.hidden,
            onSelected: (selected) => _changeFilter(LabelsFilter.hidden, selected),
          ),
          Gap(8.0),
        ],
      );
}
