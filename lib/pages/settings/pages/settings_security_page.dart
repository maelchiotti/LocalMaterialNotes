import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/preference_key.dart';
import '../dialogs/lock_delay_dialog.dart';

/// Settings related to the security of the application.
class SettingsSecurityPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const SettingsSecurityPage({super.key});

  @override
  ConsumerState<SettingsSecurityPage> createState() => _SettingsBehaviorPageState();
}

class _SettingsBehaviorPageState extends ConsumerState<SettingsSecurityPage> {
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

  /// Asks the user to configure the lock delay.
  Future<void> setLockDelay() async {
    await showAdaptiveDialog<int>(
      context: context,
      useRootNavigator: false,
      builder: (context) => const LockDelayDialog(),
    ).then((lockDelay) async {
      if (lockDelay == null) {
        return;
      }

      setState(() {
        PreferenceKey.lockAppDelay.set(lockDelay);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final flagSecure = PreferenceKey.flagSecure.preferenceOrDefault;
    final lockApp = PreferenceKey.lockApp.preferenceOrDefault;
    final lockAppDelay = PreferenceKey.lockAppDelay.preferenceOrDefault;

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
                  SettingActionTile(
                    enabled: lockApp,
                    icon: Icons.timelapse,
                    title: l.settings_application_lock_delay_title,
                    value: lockAppDelay.toString(),
                    description: l.settings_application_lock_delay_description,
                    onTap: setLockDelay,
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
