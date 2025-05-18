import 'package:flutter/material.dart';

import '../../extensions/build_context_extension.dart';
import '../../extensions/iterable_extension.dart';
import '../preference_key.dart';

/// Lists the options for the confirmations asked for user actions such as pining and deleting notes.
enum Confirmations {
  /// Never ask for a confirmation.
  none,

  /// Asks confirmations only for irreversible actions.
  irreversible,

  /// Always ask for a confirmation.
  all;

  /// The value of the preference if set, or its default value otherwise.
  factory Confirmations.fromPreference() {
    final confirmations = Confirmations.values.byNameOrNull(PreferenceKey.confirmations.preference);

    // Reset the malformed preference to its default value
    if (confirmations == null) {
      PreferenceKey.confirmations.reset();

      return Confirmations.values.byName(PreferenceKey.confirmations.defaultValue);
    }

    return confirmations;
  }

  /// The title of the preference for the settings page.
  String title(BuildContext context) {
    return switch (this) {
      none => context.l.settings_confirmations_title_none,
      irreversible => context.l.settings_confirmations_title_irreversible,
      all => context.l.settings_confirmations_title_all,
    };
  }
}
