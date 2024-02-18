import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_lock/flutter_app_lock.dart';
import 'package:local_auth/local_auth.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/asset.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/constants/sizes.dart';
import 'package:localmaterialnotes/utils/snack_bar_manager.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  Future<void> _authenticate() async {
    final localizations = AppLocalizations.of(context)!;

    var authenticated = false;
    final localeAuthentication = LocalAuthentication();
    try {
      authenticated = await localeAuthentication.authenticate(
        localizedReason: localizations.authentication_authentication_required_for_app(localizations.app_name),
      );
    } on PlatformException catch (exception, stackTrace) {
      if (exception.code != 'NotAvailable') log(exception.toString(), stackTrace: stackTrace);

      if (!mounted) return;

      SnackBarManager.info(localizations.authentication_require_credentials).show(context: context);
    } on Exception catch (exception, stackTrace) {
      log(exception.toString(), stackTrace: stackTrace);

      if (!mounted) return;

      SnackBarManager.info(localizations.authentication_error(exception.toString())).show(context: context);
    }

    if (!authenticated) return;

    if (!mounted) return;

    AppLock.of(context)!.didUnlock();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticate();
    });
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
                    Asset.icons.path,
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
                    onPressed: _authenticate,
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
