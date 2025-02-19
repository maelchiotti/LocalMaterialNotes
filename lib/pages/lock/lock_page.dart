import 'package:after_layout/after_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';
import 'package:restart_app/restart_app.dart';

import '../../common/constants/constants.dart';
import '../../common/constants/sizes.dart';
import '../../common/preferences/preference_key.dart';
import '../../common/ui/snack_bar_utils.dart';
import '../../common/widgets/asset.dart';
import '../../l10n/app_localizations/app_localizations.g.dart';

/// Lock page.
class LockPage extends ConsumerStatefulWidget {
  /// Lock page shown when the application starts if the application lock is enabled in the settings.
  const LockPage({
    super.key,
    required this.back,
    required this.description,
    required this.reason,
  });

  /// Whether to show an [AppBar] with a [BackButton].
  final bool back;

  /// The description explaining why this lock page is shown.
  final String description;

  /// The reason why the lock page is requesting a system authentication.
  final String reason;

  @override
  ConsumerState<LockPage> createState() => _LockPageState();
}

class _LockPageState extends ConsumerState<LockPage> with AfterLayoutMixin<LockPage> {
  late final LocalAuthentication localAuthentication;

  @override
  void initState() {
    super.initState();

    localAuthentication = LocalAuthentication();
  }

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    final l = AppLocalizations.of(context);

    // Ask the user to authenticate when the page is created without waiting for him to tap the 'Unlock' button
    await unlock(l);
  }

  /// Asks the user to authenticate to unlock the application.
  Future<void> unlock(AppLocalizations l) async {
    final canAuthenticate = await localAuthentication.isDeviceSupported();

    // If the device has no authentication methods available,
    // then disable the app lock and restart it to remove the lock screen
    if (!canAuthenticate) {
      await PreferenceKey.lockApp.set(false);

      // The Restart package crashes the app if used in debug mode
      if (kReleaseMode) {
        await Restart.restartApp();
      }

      return;
    }

    final bool authenticated = await localAuthentication.authenticate(localizedReason: widget.reason);

    // The authentication failed
    if (!authenticated) {
      if (!mounted) {
        return;
      }

      SnackBarUtils().show(text: l.snack_bar_authentication_failed, context: context);

      return;
    }

    if (!mounted) {
      return;
    }

    AppLock.of(context)?.didUnlock();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: widget.back
          ? AppBar(
              leading: BackButton(
                onPressed: () => Navigator.of(rootNavigatorKey.currentContext!).pop(),
              ),
            )
          : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Asset.icon.path,
                  fit: BoxFit.fitWidth,
                  width: Sizes.appIconLarge.size,
                ),
                Gap(32),
                Text(
                  l.app_name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Gap(128),
                Text(widget.description),
                Gap(16),
                FilledButton.icon(
                  onPressed: () => unlock(l),
                  icon: Icon(Icons.lock_open),
                  label: Text(l.lock_page_unlock),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
