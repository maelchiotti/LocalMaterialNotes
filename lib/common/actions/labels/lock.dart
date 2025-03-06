import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../../models/label/label.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../../preferences/preference_key.dart';
import 'select.dart';

/// Toggles whether the [labels] are locked.
Future<bool> toggleLockLabels(WidgetRef ref, {required List<Label> labels, bool requireAuthentication = false}) async {
  if (requireAuthentication) {
    final lockLabelPreference = PreferenceKey.lockLabel.preferenceOrDefault;
    final anyLocked = labels.any((label) => label.locked);

    // If the lock note setting is enabled and the note was locked, then ask to authenticate before unlocking the note
    if (lockLabelPreference && anyLocked) {
      final bool authenticated = await LocalAuthentication().authenticate(localizedReason: 'toggle');

      if (!authenticated) {
        return false;
      }
    }
  }

  final toggled = await ref.read(labelsProvider.notifier).toggleLock(labels);

  exitLabelsSelectionMode(ref);

  return toggled;
}
