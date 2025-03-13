import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../models/label/label.dart';
import '../../../../providers/labels/labels/labels_provider.dart';
import '../../../actions/labels/delete.dart';
import '../../../actions/labels/lock.dart';
import '../../../actions/labels/pin.dart';
import '../../../actions/labels/select.dart';
import '../../../actions/labels/visible.dart';
import '../../../constants/constants.dart';
import '../../../constants/paddings.dart';
import '../../../constants/separators.dart';
import '../../../constants/sizes.dart';
import '../../../preferences/preference_key.dart';
import '../../../widgets/placeholders/error_placeholder.dart';
import '../../../widgets/placeholders/loading_placeholder.dart';
import '../../enums/labels/selection_labels_menu_option.dart';

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
  Future<void> onLabelsMenuOptionSelected(
    BuildContext context,
    WidgetRef ref,
    List<Label> labels,
    SelectionLabelsMenuOption menuOption,
  ) async {
    switch (menuOption) {
      case SelectionLabelsMenuOption.togglePin:
        await togglePinLabels(ref, labels: labels);
      case SelectionLabelsMenuOption.toggleVisible:
        await toggleVisibleLabels(ref, labels: labels);
      case SelectionLabelsMenuOption.toggleLock:
        await toggleLockLabels(ref, labels: labels);
      case SelectionLabelsMenuOption.delete:
        await deleteLabels(context, ref, labels: labels);
    }
  }

  /// Builds the app bar.
  ///
  /// The title and the behavior of the buttons can change depending on the difference between
  /// the length of the [selectedLabels] and the [totalNotesCount].
  AppBar buildAppBar(List<Label> selectedLabels, int totalNotesCount) {
    final lockLabel = PreferenceKey.lockLabel.preferenceOrDefault;

    final allSelected = selectedLabels.length == totalNotesCount;

    return AppBar(
      leading: BackButton(onPressed: () => exitLabelsSelectionMode(ref)),
      title: Text('${selectedLabels.length}'),
      actions: [
        IconButton(
          icon: Icon(allSelected ? Icons.deselect : Icons.select_all),
          tooltip: allSelected ? l.tooltip_unselect_all : fl?.selectAllButtonLabel ?? 'Select all',
          onPressed: () => allSelected ? unselectAllLabels(ref) : selectAllLabels(ref),
        ),
        Padding(padding: Paddings.appBarSeparator, child: Separator.vertical(indent: 16)),
        PopupMenuButton<SelectionLabelsMenuOption>(
          itemBuilder: (context) {
            return [
              SelectionLabelsMenuOption.togglePin.popupMenuItem(context),
              SelectionLabelsMenuOption.toggleVisible.popupMenuItem(context),
              if (lockLabel) SelectionLabelsMenuOption.toggleLock.popupMenuItem(context),
              const PopupMenuDivider(),
              SelectionLabelsMenuOption.delete.popupMenuItem(context),
            ];
          },
          onSelected: (menuOption) => onLabelsMenuOptionSelected(context, ref, selectedLabels, menuOption),
        ),
        Gap(Sizes.appBarEnd.size),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(labelsProvider)
        .when(
          data: (labels) => buildAppBar(labels.where((label) => label.selected).toList(), labels.length),
          error: (exception, stackTrace) => ErrorPlaceholder(exception: exception, stackTrace: stackTrace),
          loading: () => const LoadingPlaceholder(),
        );
  }
}
