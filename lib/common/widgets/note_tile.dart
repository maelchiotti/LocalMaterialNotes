import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/actions/delete.dart';
import 'package:localmaterialnotes/common/actions/pin.dart';
import 'package:localmaterialnotes/common/actions/restore.dart';
import 'package:localmaterialnotes/common/routing/router.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/current_note/current_note_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/selection_mode/selection_mode_provider.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';
import 'package:localmaterialnotes/utils/preferences/layout.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

class NoteTile extends ConsumerStatefulWidget {
  const NoteTile(this.note) : searchView = false;

  const NoteTile.searchView(this.note) : searchView = true;

  final Note note;
  final bool searchView;

  @override
  ConsumerState<NoteTile> createState() => _NoteTileState();
}

class _NoteTileState extends ConsumerState<NoteTile> {
  void _enterSelectionMode() {
    ref.read(selectionModeProvider.notifier).enterSelectionMode();
    widget.note.deleted
        ? ref.read(binProvider.notifier).select(widget.note)
        : ref.read(notesProvider.notifier).select(widget.note);
  }

  void _openOrSelect() {
    if (ref.watch(selectionModeProvider)) {
      if (widget.note.deleted) {
        widget.note.selected
            ? ref.read(binProvider.notifier).unselect(widget.note)
            : ref.read(binProvider.notifier).select(widget.note);
      } else {
        widget.note.selected
            ? ref.read(notesProvider.notifier).unselect(widget.note)
            : ref.read(notesProvider.notifier).select(widget.note);
      }
    } else {
      ref.read(currentNoteProvider.notifier).set(widget.note);

      context.push(
        RouterRoute.editor.fullPath!,
        extra: EditorParameters.from({'readonly': widget.note.deleted, 'autofocus': false}),
      );

      if (widget.searchView) {
        context.pop();
      }
    }
  }

  Future<bool> _dismiss(DismissDirection direction) {
    switch (direction) {
      case DismissDirection.startToEnd:
        return widget.note.deleted
            ? permanentlyDeleteNote(context, ref, widget.note)
            : deleteNote(context, ref, widget.note);
      case DismissDirection.endToStart:
        return widget.note.deleted ? restoreNote(context, ref, widget.note) : togglePinNote(context, ref, widget.note);
      default:
        return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final layout = PreferenceKey.layout.getPreferenceOrDefault<Layout>();
    final isTitleEmpty = widget.note.title.isEmpty;

    final tile = ListTile(
      contentPadding: Paddings.padding16.horizontal.add(Paddings.padding8.vertical),
      selected: widget.note.selected,
      selectedTileColor: Theme.of(context).colorScheme.surfaceVariant,
      title: Row(
        children: [
          Expanded(
            child: Text(
              isTitleEmpty ? localizations.notes_untitled : widget.note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: isTitleEmpty ? FontStyle.italic : null,
                  ),
            ),
          ),
          Padding(padding: Paddings.padding4.horizontal),
          if (widget.note.pinned && !widget.note.deleted)
            Icon(
              Icons.push_pin,
              size: Sizes.size16.size,
            ),
        ],
      ),
      subtitle: widget.note.contentDisplay.isNotEmpty
          ? Text(
              widget.note.contentDisplay,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withAlpha(175),
                  ),
            )
          : null,
      onTap: _openOrSelect,
      onLongPress: widget.searchView ? null : _enterSelectionMode,
    );

    return layout == Layout.list
        ? Dismissible(
            key: Key(widget.note.id.toString()),
            background: widget.note.deleted
                ? ColoredBox(
                    color: Colors.red,
                    child: Row(
                      children: [
                        Padding(padding: Paddings.padding8.horizontal),
                        const Icon(Icons.delete_forever),
                        Padding(padding: Paddings.padding4.horizontal),
                        Text(
                          localizations.dismiss_permanently_delete,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  )
                : ColoredBox(
                    color: Colors.red,
                    child: Row(
                      children: [
                        Padding(padding: Paddings.padding8.horizontal),
                        const Icon(Icons.delete),
                        Padding(padding: Paddings.padding4.horizontal),
                        Text(
                          localizations.dismiss_delete,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
            secondaryBackground: widget.note.deleted
                ? ColoredBox(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.restore_from_trash),
                        Padding(padding: Paddings.padding4.horizontal),
                        Text(
                          localizations.dismiss_restore,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Padding(padding: Paddings.padding8.horizontal),
                      ],
                    ),
                  )
                : ColoredBox(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          widget.note.pinned ? Icons.push_pin_outlined : Icons.push_pin,
                        ),
                        Padding(padding: Paddings.padding4.horizontal),
                        Text(
                          widget.note.pinned ? localizations.dismiss_unpin : localizations.dismiss_pin,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Padding(padding: Paddings.padding8.horizontal),
                      ],
                    ),
                  ),
            confirmDismiss: _dismiss,
            child: tile,
          )
        : tile;
  }
}
