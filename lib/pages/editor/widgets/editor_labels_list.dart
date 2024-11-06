import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:localmaterialnotes/common/actions/notes/labels.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';
import 'package:localmaterialnotes/common/widgets/labels/label_badge.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

class EditorLabelsList extends ConsumerWidget {
  const EditorLabelsList({
    super.key,
    required this.readOnly,
  });

  /// Whether the page should be read only.
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
        valueListenable: currentNoteNotifier,
        builder: (context, currentNote, child) {
          if (currentNote == null) {
            return LoadingPlaceholder();
          }

          if (currentNote.labels.isEmpty) {
            return EmptyPlaceholder();
          }

          final labels = currentNote.labelsSorted;

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
