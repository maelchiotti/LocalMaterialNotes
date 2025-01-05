import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/label/label.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../../actions/labels/delete.dart';
import '../../actions/labels/pin.dart';
import '../../actions/labels/select.dart';
import '../../actions/labels/visible.dart';
import '../../constants/constants.dart';
import '../../constants/paddings.dart';
import '../../constants/separators.dart';
import '../../widgets/placeholders/error_placeholder.dart';
import '../../widgets/placeholders/loading_placeholder.dart';

/// Labels selection mode app bar.
///
/// Contains:
///   - A back button.
///   - The number of currently selected labels.
///   - A button to select / unselect all labels.
///   - A button to toggle the pin status of the selected notes.
///   - A button to toggle the visible status the selected notes.
class LabelsSelectionAppBar extends ConsumerStatefulWidget {
  /// Default constructor.
  const LabelsSelectionAppBar({super.key});

  @override
  ConsumerState<LabelsSelectionAppBar> createState() => _SelectionAppBarState();
}

class _SelectionAppBarState extends ConsumerState<LabelsSelectionAppBar> {
  /// Builds the app bar.
  ///
  /// The title and the behavior of the buttons can change depending on the difference between
  /// the length of the [selectedLabels] and the [totalNotesCount].
  AppBar buildAppBar(List<Label> selectedLabels, int totalNotesCount) {
    final allSelected = selectedLabels.length == totalNotesCount;

    return AppBar(
      leading: BackButton(
        onPressed: () => exitLabelsSelectionMode(ref),
      ),
      title: Text('${selectedLabels.length}'),
      actions: [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          tooltip: allSelected ? l.tooltip_unselect_all : flutterL?.selectAllButtonLabel ?? 'Select all',
          onPressed: () => allSelected ? unselectAllLabels(ref) : selectAllLabels(ref),
        ),
        Padding(padding: Paddings.appBarActionsEnd),
        Separator.divider1indent16.vertical,
        Padding(padding: Paddings.appBarActionsEnd),
        IconButton(
          icon: const Icon(Icons.push_pin),
          tooltip: l.action_labels_toggle_pins,
          onPressed: selectedLabels.isNotEmpty ? () => togglePinLabels(ref, selectedLabels) : null,
        ),
        IconButton(
          icon: const Icon(Icons.visibility),
          tooltip: l.action_labels_toggle_visibility,
          onPressed: selectedLabels.isNotEmpty ? () => toggleVisibleLabels(ref, selectedLabels) : null,
        ),
        IconButton(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
          tooltip: l.tooltip_delete,
          onPressed: selectedLabels.isNotEmpty ? () => deleteLabels(context, ref, selectedLabels) : null,
        ),
        Padding(padding: Paddings.appBarActionsEnd),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(labelsProvider).when(
          data: (labels) => buildAppBar(labels.where((label) => label.selected).toList(), labels.length),
          error: (exception, stackTrace) => ErrorPlaceholder(exception: exception, stackTrace: stackTrace),
          loading: () => const LoadingPlaceholder(),
        );
  }
}
