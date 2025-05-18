import 'package:flutter/material.dart';

import '../../l10n/app_localizations/app_localizations.g.dart';

/// Extensions on the [BuildContext] class.
extension BuildContextExtension on BuildContext {
  /// Application localizations.
  AppLocalizations get l => AppLocalizations.of(this);

  /// Flutter localizations.
  MaterialLocalizations get fl => Localizations.of<MaterialLocalizations>(this, MaterialLocalizations)!;
}
