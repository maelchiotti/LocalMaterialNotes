import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';

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

    if (!mounted) {
      return;
    }

    toggled ? AppLock.of(context)?.enable() : AppLock.of(context)?.disable();

    setState(() {});
  }

  /// Toggles whether the notes is locked to [toggled].
  Future<void> toggledLockNotes(bool toggled) async {
    await PreferenceKey.lockNote.set(toggled);

    setState(() {});
  }

  /// Sets the application lock delay to [delay].
  Future<void> submittedLockAppDelay(double delay) async {
    setState(() {
      PreferenceKey.lockAppDelay.set(delay.toInt());
    });

    AppLock.of(context)?.setBackgroundLockLatency(Duration(seconds: delay.toInt()));
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

    final lockNotes = PreferenceKey.lockNote.preferenceOrDefault;
    final lockNoteDelay = PreferenceKey.lockNoteDelay.preferenceOrDefault;

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
                    icon: Icons.lock,
                    title: l.settings_application_lock_title,
                    description: l.settings_application_lock_description,
                    toggled: lockApp,
                    onChanged: toggledLockApp,
                  ),
                  SettingCustomSliderTile(
                    enabled: lockApp,
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
                    icon: Icons.lock,
                    title: l.settings_note_lock_title,
                    description: l.settings_note_lock_description,
                    toggled: lockNotes,
                    onChanged: toggledLockNotes,
                  ),
                  SettingCustomSliderTile(
                    enabled: lockNotes,
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
