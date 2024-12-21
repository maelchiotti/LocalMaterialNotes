import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../common/actions/notes/labels.dart';
import '../../../common/constants/sizes.dart';
import '../../../common/widgets/labels/label_badge.dart';
import '../../../common/widgets/placeholders/loading_placeholder.dart';
import '../../../providers/notifiers/notifiers.dart';

/// List of labels in the editor.
class EditorLabelsList extends ConsumerWidget {
  /// The list of labels of the current note at the bottom of the notes editor.
  const EditorLabelsList({
    super.key,
    required this.readOnly,
  });

  /// Whether the page is read only.
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
        valueListenable: currentNoteNotifier,
        builder: (context, currentNote, child) {
          if (currentNote == null) {
            return LoadingPlaceholder();
          }

          final labels = currentNote.labelsVisibleSorted;

          return ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: readOnly ? null : () => selectLabels(context, ref, currentNote),
                child: SizedBox(
                  height: Sizes.editorLabelsListHeight.size,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      itemBuilder: (context, index) {
                        return LabelBadge(label: labels[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Gap(4.0);
                      },
                      itemCount: labels.length,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
