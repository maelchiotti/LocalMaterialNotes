import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:localmaterialnotes/common/actions/notes/labels.dart';
import 'package:localmaterialnotes/common/widgets/labels/label_badge.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

class EditorLabelsList extends ConsumerStatefulWidget {
  const EditorLabelsList({
    super.key,
  });

  @override
  ConsumerState<EditorLabelsList> createState() => _EditorLabelsListState();
}

class _EditorLabelsListState extends ConsumerState<EditorLabelsList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
          valueListenable: currentNoteNotifier,
          builder: (context, currentNote, child) {
            if (currentNote == null) {
              return LoadingPlaceholder();
            }

            if (currentNote.labels.isEmpty) {
              return EmptyPlaceholder();
            }

            final labels = currentNote.labels.toList();

            return InkWell(
              onTap: () => selectLabels(context, ref, currentNote),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 24,
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
            );
          }),
    );
  }
}
