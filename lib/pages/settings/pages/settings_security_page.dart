import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/enums/swipe_actions/available_swipe_action.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/system_utils.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Settings related to the security of the application.
class SettingsSecurityPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const SettingsSecurityPage({super.key});

  @override
  ConsumerState<SettingsSecurityPage> createState() => _SettingsBehaviorPageState();
}

class _SettingsBehaviorPageState extends ConsumerState<SettingsSecurityPage> {
  late final LocalAuthentication localAuthentication;

  @override
  void initState() {
    super.initState();

    localAuthentication = LocalAuthentication();
  }

  /// Toggles whether Android's `FLAG_SECURE` is enabled to [toggled].
  Future<void> toggledFlagSecure(bool toggled) async {
    await PreferenceKey.flagSecure.set(toggled);

    toggled ? await FlagSecure.set() : await FlagSecure.unset();

    setState(() {});
  }

  /// Toggles whether the application is locked to [toggled].
  Future<void> toggledLockApp(bool toggled) async {
    await PreferenceKey.lockApp.set(toggled);

    lockAppNotifier.value = toggled;

    if (!mounted) {
      return;
    }

    setState(() {});
  }

  /// Toggles whether the notes can be locked to [toggled].
  Future<void> toggledLockNote(bool toggled) async {
    await PreferenceKey.lockNote.set(toggled);

    // If the note lock is disabled and the available swipe actions are 'Lock / Unlock', set them to disabled
    if (!toggled) {
      final availableSwipeActionsPreferences = (
        right: PreferenceKey.swipeRightAction.preferenceOrDefault,
        left: PreferenceKey.swipeLeftAction.preferenceOrDefault,
      );
      final availableSwipeActions = (
        right: AvailableSwipeAction.rightFromPreference(preference: availableSwipeActionsPreferences.right),
        left: AvailableSwipeAction.leftFromPreference(preference: availableSwipeActionsPreferences.left),
      );

      if (availableSwipeActions.right == AvailableSwipeAction.toggleLock) {
        await PreferenceKey.swipeRightAction.set(AvailableSwipeAction.disabled.name);
      }
      if (availableSwipeActions.left == AvailableSwipeAction.toggleLock) {
        await PreferenceKey.swipeLeftAction.set(AvailableSwipeAction.disabled.name);
      }
    }

    setState(() {});
  }

  /// Toggles whether the labels can be locked to [toggled].
  Future<void> toggledLockLabel(bool toggled) async {
    await PreferenceKey.lockLabel.set(toggled);

    setState(() {});
  }

  /// Sets the application lock delay to [delay].
  Future<void> submittedLockAppDelay(double delay) async {
    setState(() {
      PreferenceKey.lockAppDelay.set(delay.toInt());
    });
  }

  /// Sets the note lock delay to [delay].
  Future<void> submittedLockNoteDelay(double delay) async {
    setState(() {
      PreferenceKey.lockNoteDelay.set(delay.toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    final flagSecure = PreferenceKey.flagSecure.preferenceOrDefault;

    final lockApp = PreferenceKey.lockApp.preferenceOrDefault;
    final lockAppDelay = PreferenceKey.lockAppDelay.preferenceOrDefault;

    final lockNote = PreferenceKey.lockNote.preferenceOrDefault;
    final lockLabel = PreferenceKey.lockLabel.preferenceOrDefault;
    final lockNoteDelay = PreferenceKey.lockNoteDelay.preferenceOrDefault;

    final isSystemAuthenticationAvailable = SystemUtils().isSystemAuthenticationAvailable;

    return Scaffold(
      appBar: TopNavigation(
        appbar: BasicAppBar(title: l.navigation_settings_security),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_security_application,
                tiles: [
                  SettingSwitchTile(
                    icon: Icons.screenshot,
                    title: l.settings_flag_secure,
                    description: l.settings_flag_secure_description,
                    toggled: flagSecure,
                    onChanged: toggledFlagSecure,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_security_application_lock,
                tiles: [
                  SettingSwitchTile(
                    enabled: isSystemAuthenticationAvailable,
                    icon: Icons.lock,
                    title: l.settings_application_lock_title,
                    description: l.settings_application_lock_description,
                    toggled: lockApp,
                    onChanged: toggledLockApp,
                  ),
                  SettingCustomSliderTile(
                    enabled: isSystemAuthenticationAvailable && lockApp,
                    icon: Icons.timelapse,
                    title: l.settings_application_lock_delay_title,
                    value: l.settings_lock_delay_value(lockAppDelay.toString()),
                    description: l.settings_application_lock_delay_description,
                    dialogTitle: l.settings_application_lock_delay_title,
                    label: (delay) => l.settings_lock_delay_value(delay.toInt().toString()),
                    values: lockDelayValues,
                    initialValue: lockAppDelay.toDouble(),
                    onSubmitted: submittedLockAppDelay,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_security_note_lock,
                tiles: [
                  SettingSwitchTile(
                    enabled: isSystemAuthenticationAvailable,
                    icon: Icons.notes,
                    title: l.settings_note_lock_title,
                    description: l.settings_note_lock_description,
                    toggled: lockNote,
                    onChanged: toggledLockNote,
                  ),
                  SettingSwitchTile(
                    enabled: isSystemAuthenticationAvailable,
                    icon: Icons.label,
                    title: l.settings_label_lock_title,
                    description: l.settings_label_lock_description,
                    toggled: lockLabel,
                    onChanged: toggledLockLabel,
                  ),
                  SettingCustomSliderTile(
                    enabled: isSystemAuthenticationAvailable && lockNote,
                    icon: Icons.timelapse,
                    title: l.settings_note_lock_delay_title,
                    value: l.settings_lock_delay_value(lockNoteDelay.toString()),
                    description: l.settings_note_lock_delay_description,
                    dialogTitle: l.settings_note_lock_delay_title,
                    label: (delay) => l.settings_lock_delay_value(delay.toInt().toString()),
                    values: lockDelayValues,
                    initialValue: lockNoteDelay.toDouble(),
                    onSubmitted: submittedLockNoteDelay,
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
