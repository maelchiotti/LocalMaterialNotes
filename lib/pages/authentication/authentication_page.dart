import 'package:flutter/material.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:local_auth/local_auth.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/asset.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  Future<void> _authenticate(BuildContext context, AppLocalizations localizations) async {
    final localeAuthentication = LocalAuthentication();
    final authenticated = await localeAuthentication.authenticate(
      localizedReason: localizations.authentication_authentication_required_for_app(localizations.app_name),
    );

    if (!authenticated) return;

    if (context.mounted) {
      AppLock.of(context)!.didUnlock();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Material(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Asset.icon.path,
                    filterQuality: FilterQuality.medium,
                    fit: BoxFit.fitWidth,
                    width: Sizes.size128.size,
                  ),
                  Padding(padding: Paddings.padding16.vertical),
                  Text(
                    localizations.app_name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Padding(padding: Paddings.padding4.vertical),
                  Text(localizations.authentication_authentication_required),
                  Padding(padding: Paddings.padding16.vertical),
                  FilledButton.icon(
                    onPressed: () => _authenticate(context, localizations),
                    icon: const Icon(Icons.fingerprint),
                    label: Text(localizations.authentication_authenticate),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
