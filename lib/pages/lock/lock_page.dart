import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../common/actions/authentication.dart';
import '../../common/constants/sizes.dart';
import '../../common/widgets/asset.dart';
import '../../l10n/app_localizations/app_localizations.g.dart';
import '../../providers/notifiers/lock_notifier.dart';

/// Lock page.
class LockPage extends ConsumerStatefulWidget {
  /// Lock page shown when the application starts if the application lock is enabled in the settings.
  const LockPage({
    super.key,
    required this.lockNotifier,
    required this.back,
    required this.description,
    required this.reason,
  });

  /// The lock notifier to update when unlocking the page.
  final LockNotifier lockNotifier;

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
  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    final l = AppLocalizations.of(context);

    // Ask the user to authenticate when the page is created without waiting for him to tap the 'Unlock' button
    await unlock(l);
  }

  /// Asks the user to authenticate to unlock the application.
  Future<void> unlock(AppLocalizations l) async {
    final bool authenticated = await authenticate(context, reason: widget.reason);

    if (!authenticated) {
      return;
    }

    widget.lockNotifier.unlock();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: widget.back ? AppBar(leading: BackButton()) : null,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Asset.icon.path, fit: BoxFit.fitWidth, width: Sizes.appIconLarge.size),
                Gap(32),
                Text(l.app_name, style: Theme.of(context).textTheme.headlineMedium),
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
