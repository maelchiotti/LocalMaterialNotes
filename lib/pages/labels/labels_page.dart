import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/paddings.dart';
import '../../common/navigation/app_bars/labels/labels_app_bar.dart';
import '../../common/navigation/side_navigation.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/widgets/placeholders/empty_placeholder.dart';
import '../../common/widgets/placeholders/error_placeholder.dart';
import '../../common/widgets/placeholders/loading_placeholder.dart';
import '../../providers/labels/labels/labels_provider.dart';
import '../../providers/notifiers/notifiers.dart';
import 'widgets/add_label_fab.dart';
import 'widgets/label_tile.dart';
import 'widgets/labels_filters.dart';

/// Labels page.
class LabelsPage extends ConsumerWidget {
  /// Page showing the list of labels with filters.
  const LabelsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(labelsProvider)
        .when(
          data: (labels) {
            return Scaffold(
              appBar: TopNavigation(appbar: LabelsAppBar()),
              drawer: const SideNavigation(),
              floatingActionButton: const AddLabelFab(),
              body: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: labelsFiltersNotifier,
                    builder: (context, labelsFilters, child) {
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 250),
                        switchInCurve: Curves.easeInOut,
                        switchOutCurve: Curves.easeInOut,
                        transitionBuilder: (child, animation) {
                          return SizeTransition(axisAlignment: 1, sizeFactor: animation, child: child);
                        },
                        child: labelsFilters ? SizedBox(height: 38, child: LabelsFilters()) : null,
                      );
                    },
                  ),
                  Expanded(
                    child:
                        labels.isEmpty
                            ? EmptyPlaceholder.labels()
                            : ListView.builder(
                              padding: Paddings.fab,
                              itemCount: labels.length,
                              itemBuilder: (BuildContext context, int index) {
                                return LabelTile(label: labels[index]);
                              },
                            ),
                  ),
                ],
              ),
            );
          },
          error: (exception, stackTrace) => ErrorPlaceholder(exception: exception, stackTrace: stackTrace),
          loading: () => const LoadingPlaceholder(),
        );
  }
}
