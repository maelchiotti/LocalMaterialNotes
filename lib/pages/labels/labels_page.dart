import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/basic_app_bar.dart';
import 'package:localmaterialnotes/common/navigation/side_navigation.dart';
import 'package:localmaterialnotes/common/navigation/top_navigation.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/pages/labels/widgets/add_label_fab.dart';
import 'package:localmaterialnotes/pages/labels/widgets/label_tile.dart';
import 'package:localmaterialnotes/pages/labels/widgets/labels_filters.dart';
import 'package:localmaterialnotes/providers/labels/labels/labels_provider.dart';

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
      data: (labels) {
        return Scaffold(
          appBar: TopNavigation(
            appbar: BasicAppBar(
              title: l.navigation_manage_labels_page,
              back: true,
            ),
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
        );
      },
      error: (exception, stackTrace) {
        return ErrorPlaceholder(exception: exception, stackTrace: stackTrace);
      },
      loading: () {
        return const LoadingPlaceholder();
      },
    );
  }
}
