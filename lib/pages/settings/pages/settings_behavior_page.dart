import 'package:flag_secure/flag_secure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/constants/constants.dart';
import '../../../common/constants/paddings.dart';
import '../../../common/navigation/app_bars/basic_app_bar.dart';
import '../../../common/navigation/top_navigation.dart';
import '../../../common/preferences/enums/confirmations.dart';
import '../../../common/preferences/enums/swipe_action.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../utils/keys.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../../common/preferences/watched_preferences.dart';
import '../../../providers/preferences/preferences_provider.dart';

/// Settings related to the behavior of the application.
class SettingsBehaviorPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const SettingsBehaviorPage({super.key});

  @override
  ConsumerState<SettingsBehaviorPage> createState() => _SettingsBehaviorPageState();
}

class _SettingsBehaviorPageState extends ConsumerState<SettingsBehaviorPage> {
  /// Asks the user to choose which confirmations should be shown.
  void _submittedConfirmations(Confirmations confirmations) {
    setState(() {
      PreferenceKey.confirmations.set(confirmations.name);
    });
  }

  /// Sets the new right [swipeAction].
  void _submittedSwipeRightAction(SwipeAction swipeAction) {
    PreferenceKey.swipeRightAction.set(swipeAction.name);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(rightSwipeAction: swipeAction));
  }

  /// Sets the new left [swipeAction].
  void _submittedSwipeLeftAction(SwipeAction swipeAction) {
    PreferenceKey.swipeLeftAction.set(swipeAction.name);

    ref.read(preferencesProvider.notifier).update(WatchedPreferences(leftSwipeAction: swipeAction));
  }

  /// Toggles Android's `FLAG_SECURE` to hide the app from the recent apps and prevent screenshots.
  Future<void> _setFlagSecure(bool toggled) async {
    setState(() {
      PreferenceKey.flagSecure.set(toggled);
    });

    toggled ? await FlagSecure.set() : await FlagSecure.unset();
  }

  @override
  Widget build(BuildContext context) {
    final confirmations = Confirmations.fromPreference();
    final flagSecure = PreferenceKey.flagSecure.getPreferenceOrDefault();

    final swipeActions = ref.watch(preferencesProvider.select((preferences) => preferences.swipeActions));

    return Scaffold(
      appBar: TopNavigation(
        key: Keys.appBarSettingsMainSubpage,
        appbar: BasicAppBar(
          title: l.navigation_settings_behavior,
          back: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Paddings.bottomSystemUi,
          child: Column(
            children: [
              SettingSection(
                divider: null,
                title: l.settings_behavior_application,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.warning,
                    title: l.settings_confirmations,
                    value: confirmations.title,
                    description: l.settings_confirmations_description,
                    dialogTitle: l.settings_confirmations,
                    options: Confirmations.values
                        .map(
                          (confirmation) => (
                            value: confirmation,
                            title: confirmation.title,
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: confirmations,
                    onSubmitted: _submittedConfirmations,
                  ),
                  SettingSwitchTile(
                    icon: Icons.security,
                    title: l.settings_flag_secure,
                    description: l.settings_flag_secure_description,
                    toggled: flagSecure,
                    onChanged: _setFlagSecure,
                  ),
                ],
              ),
              SettingSection(
                divider: null,
                title: l.settings_behavior_swipe_actions,
                tiles: [
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_right,
                    title: l.settings_swipe_action_right,
                    value: swipeActions.right.title(),
                    description: l.settings_swipe_action_right_description,
                    dialogTitle: l.settings_swipe_action_right,
                    options: SwipeAction.values
                        .map(
                          (swipeAction) => (
                            value: swipeAction,
                            title: swipeAction.title(),
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: swipeActions.right,
                    onSubmitted: _submittedSwipeRightAction,
                  ),
                  SettingSingleOptionTile.detailed(
                    icon: Icons.swipe_left,
                    title: l.settings_swipe_action_left,
                    value: swipeActions.left.title(),
                    description: l.settings_swipe_action_left_description,
                    dialogTitle: l.settings_swipe_action_left,
                    options: SwipeAction.values
                        .map(
                          (swipeAction) => (
                            value: swipeAction,
                            title: swipeAction.title(),
                            subtitle: null,
                          ),
                        )
                        .toList(),
                    initialOption: swipeActions.left,
                    onSubmitted: _submittedSwipeLeftAction,
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
