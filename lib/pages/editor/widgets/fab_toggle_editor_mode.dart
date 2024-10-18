import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/paddings.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// Floating action button to toggle the editor between editing mode and reading mode.
class FabToggleEditorMode extends ConsumerWidget {
  /// Default constructor.
  const FabToggleEditorMode({super.key});

  /// Switches the editor mode between editing and viewing.
  void _switchMode() {
    isFleatherEditorEditMode.value = !isFleatherEditorEditMode.value;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault<bool>();

    return ValueListenableBuilder(
      valueListenable: isFleatherEditorEditMode,
      builder: (context, isEditMode, child) {
        return Padding(
          padding: showToolbar && isEditMode ? Paddings.fabToggleEditorModeWithToolbarBottom : EdgeInsets.zero,
          child: FloatingActionButton.small(
            tooltip: isEditMode ? l.tooltip_fab_toggle_editor_mode_read : l.tooltip_fab_toggle_editor_mode_edit,
            onPressed: _switchMode,
            child: Icon(isEditMode ? Icons.visibility : Icons.edit),
          ),
        );
      },
    );
  }
}
