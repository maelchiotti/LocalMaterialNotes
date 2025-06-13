import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/paddings.dart';
import '../../../common/extensions/build_context_extension.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/enums/toolbar_style.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/system_utils.dart';
import '../../../models/note/types/note_type.dart';

/// Notes types settings.
class SettingsNotesTypesPage extends ConsumerStatefulWidget {
  /// Settings page related to the notes types.
  const SettingsNotesTypesPage({super.key});

  @override
  ConsumerState<SettingsNotesTypesPage> createState() => _SettingsNotesTypesPageState();
}

class _SettingsNotesTypesPageState extends ConsumerState<SettingsNotesTypesPage> {
  /// Sets the setting for the available notes types to [availableNotesTypes].
  void onSubmittedAvailableNotesTypes(List<NoteType> availableNotesTypes) {
    PreferenceKey.availableNotesTypes.set(NoteType.toPreference(availableNotesTypes));

    SystemUtils().setQuickActions(context);

    setState(() {});
  }

  /// Sets the setting for the default share note type to [defaultShareNoteType].
  Future<void> onSubmittedDefaultShareNoteType(NoteType defaultShareNoteType) async {
    await PreferenceKey.defaultShareNoteType.set(defaultShareNoteType.name);

    setState(() {});
  }

  /// Sets the setting for the toolbar style to [toolbarStyle].
  Future<void> onSubmittedToolbarStyle(ToolbarStyle toolbarStyle) async {
    await PreferenceKey.toolbarStyle.set(toolbarStyle.name);

    setState(() {});
  }

  /// Toggles the setting to use spacing between the paragraphs.
  Future<void> _toggleUseParagraphSpacing(bool toggled) async {
    await PreferenceKey.useParagraphsSpacing.set(toggled);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final notesTypes = NoteType.values.map((type) {
      return (value: type, title: type.title(context), subtitle: null);
    }).toList();
    final availableNotesTypes = NoteType.available;
    final availableNotesTypesString = NoteType.availableAsString(context);

    final shareNotesTypes = NoteType.share.map((type) {
      return (value: type, title: type.title(context), subtitle: null);
    }).toList();
    final defaultShareNoteType = NoteType.defaultShare;

    final toolbarStyle = ToolbarStyle.fromPreference();
    final toolbarStyleOptions = ToolbarStyle.values.map((toolbarStyle) {
      return (value: toolbarStyle, title: toolbarStyle.title(context), subtitle: toolbarStyle.description(context));
    }).toList();
    final useParagraphsSpacing = PreferenceKey.useParagraphsSpacing.preferenceOrDefault;

    return Scaffold(
      appBar: TopNavigation(appbar: BasicAppBar(title: context.l.navigation_settings_notes_types)),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: context.l.settings_section_types_to_use,
                tiles: [
                  SettingMultipleOptionsTile.detailed(
                    icon: Icons.edit_note,
                    title: context.l.settings_available_notes_types,
                    value: availableNotesTypesString,
                    description: context.l.settings_available_notes_types_description,
                    dialogTitle: context.l.settings_available_notes_types,
                    options: notesTypes,
                    initialOptions: availableNotesTypes,
                    minOptions: 1,
                    onSubmitted: onSubmittedAvailableNotesTypes,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.share,
                    title: context.l.settings_available_default_share_type,
                    value: defaultShareNoteType.title(context),
                    description: context.l.settings_available_default_share_type_description,
                    dialogTitle: context.l.settings_available_default_share_type,
                    options: shareNotesTypes,
                    initialOption: defaultShareNoteType,
                    onSubmitted: onSubmittedDefaultShareNoteType,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: NoteType.richText.title(context),
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.format_paint,
                    title: context.l.settings_toolbar_style_title,
                    value: toolbarStyle.title(context),
                    description: context.l.settings_toolbar_style_description,
                    dialogTitle: context.l.settings_toolbar_style_title,
                    options: toolbarStyleOptions,
                    initialOption: toolbarStyle,
                    onSubmitted: onSubmittedToolbarStyle,
                  ),
                  SettingSwitchTile(
                    icon: Icons.format_line_spacing,
                    title: context.l.settings_use_paragraph_spacing,
                    description: context.l.settings_use_paragraph_spacing_description,
                    toggled: useParagraphsSpacing,
                    onChanged: _toggleUseParagraphSpacing,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
