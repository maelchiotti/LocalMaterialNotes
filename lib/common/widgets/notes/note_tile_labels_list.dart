import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../labels/label_badge.dart';
import '../labels/label_placeholder_badge.dart';

/// List of labels on note tiles.
class NoteTileLabelsList extends ConsumerStatefulWidget {
  /// The list of labels of the [note] on the note tiles.
  const NoteTileLabelsList({
    super.key,
    required this.note,
  });

  /// The note for which the labels are displayed.
  final Note note;

  @override
  ConsumerState<NoteTileLabelsList> createState() => _NoteTileWidgetsState();
}

class _NoteTileWidgetsState extends ConsumerState<NoteTileLabelsList> {
  final maxLabels = 3;

  @override
  Widget build(BuildContext context) {
    final noteLabels = widget.note.labelsVisibleSorted;

    // Wrap with a SizedBox to allow the labels to align to the start of the tile
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 4.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          ...noteLabels.take(maxLabels).map((label) => LabelBadge(label: label)),
          if (noteLabels.length > maxLabels) LabelPlaceholderBadge(text: '+ ${noteLabels.length - maxLabels}'),
        ],
      ),
    );
  }
}
