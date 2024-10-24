import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:localmaterialnotes/providers/labels/labels/labels_provider.dart';

class LabelsFilters extends ConsumerStatefulWidget {
  const LabelsFilters({super.key});

  @override
  ConsumerState<LabelsFilters> createState() => _LabelsFiltersState();
}

class _LabelsFiltersState extends ConsumerState<LabelsFilters> {
  bool _onlyPinned = false;
  bool _onlyHidden = false;

  Future<void> _filter() async {
    await ref.read(labelsProvider.notifier).filter(
          _onlyPinned,
          _onlyHidden,
        );
  }

  void _toggleOnlyPinned(bool value) {
    setState(() {
      _onlyPinned = value;
    });

    _filter();
  }

  void _toggleOnlyHidden(bool value) {
    setState(() {
      _onlyHidden = value;
    });

    _filter();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Gap(8.0),
        FilterChip(
          label: Text('Pinned'),
          selected: _onlyPinned,
          onSelected: _toggleOnlyPinned,
        ),
        Gap(8.0),
        FilterChip(
          label: Text('Hidden'),
          selected: _onlyHidden,
          onSelected: _toggleOnlyHidden,
        ),
        Gap(8.0),
      ],
    );
  }
}
