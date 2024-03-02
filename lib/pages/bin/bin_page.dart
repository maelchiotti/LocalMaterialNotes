import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/note_tile.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/separators.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

class BinPage extends ConsumerStatefulWidget {
  const BinPage();

  @override
  ConsumerState<BinPage> createState() => _BinPageState();
}

class _BinPageState extends ConsumerState<BinPage> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(binProvider).when(
      data: (notes) {
        if (notes.isEmpty) return EmptyPlaceholder.bin();

        final useSeparators =
            PreferencesManager().get<bool>(PreferenceKey.separator) ?? PreferenceKey.separator.defaultValue! as bool;

        return useSeparators
            ? ListView.separated(
                padding: Paddings.custom.fab,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return NoteTile(notes[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Separator.divider1indent8.horizontal;
                },
              )
            : ListView.builder(
                padding: Paddings.custom.fab,
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return NoteTile(notes[index]);
                },
              );
      },
      error: (error, stackTrace) {
        return const ErrorPlaceholder();
      },
      loading: () {
        return const LoadingPlaceholder();
      },
    );
  }
}
