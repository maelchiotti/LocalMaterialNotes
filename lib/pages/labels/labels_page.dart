import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../../common/constants/paddings.dart';
import '../../common/navigation/app_bars/basic_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/widgets/placeholders/empty_placeholder.dart';
import '../../common/widgets/placeholders/error_placeholder.dart';
import '../../common/widgets/placeholders/loading_placeholder.dart';
import '../../providers/labels/labels/labels_provider.dart';
import 'widgets/add_label_fab.dart';
import 'widgets/label_tile.dart';
import 'widgets/labels_filters.dart';

/// Page displaying the labels.
///
/// Contains:
///   - The list of labels.
///   - The FAB to add a label.
class LabelsPage extends ConsumerWidget {
  /// Default constructor.
  const LabelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(labelsProvider).when(
          data: (labels) => Scaffold(
            appBar: TopNavigation(
              appbar: BasicAppBar(title: l.navigation_manage_labels_page),
            ),
            drawer: const SideNavigation(),
            floatingActionButton: const AddLabelFab(),
            body: Column(
              children: [
                SizedBox(
                  height: 48,
                  child: LabelsFilters(),
                ),
                Expanded(
                  child: labels.isEmpty
                      ? EmptyPlaceholder.labels()
                      : ListView(
                          padding: Paddings.fab,
                          children: [
                            for (final label in labels) LabelTile(label: label),
                          ],
                        ),
                ),
              ],
            ),
          ),
          error: (exception, stackTrace) => ErrorPlaceholder(exception: exception, stackTrace: stackTrace),
          loading: () => const LoadingPlaceholder(),
        );
  }
}
