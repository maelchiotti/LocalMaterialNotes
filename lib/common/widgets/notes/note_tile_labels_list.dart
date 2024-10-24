import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/widgets/labels/label_badge.dart';
import 'package:localmaterialnotes/common/widgets/labels/label_placeholder_badge.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/labels/labels_list/labels_list_provider.dart';

class NoteTileLabelsList extends ConsumerStatefulWidget {
  const NoteTileLabelsList({
    super.key,
    required this.note,
  });

  final Note note;

  @override
  ConsumerState<NoteTileLabelsList> createState() => _NoteTileWidgetsState();
}

class _NoteTileWidgetsState extends ConsumerState<NoteTileLabelsList> {
  final maxLabels = 3;

  @override
  Widget build(BuildContext context) {
    return ref.watch(labelsListProvider).when(
      data: (labels) {
        final noteLabels = widget.note.labels.toList();

        // Wrap with a SizedBox to allow the labels to align to the start of the tile
        return SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              ...noteLabels.take(maxLabels).map((label) {
                return LabelBadge(label: label);
              }),
              if (noteLabels.length > maxLabels) LabelPlaceholderBadge(text: '+ ${noteLabels.length - maxLabels}')
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
