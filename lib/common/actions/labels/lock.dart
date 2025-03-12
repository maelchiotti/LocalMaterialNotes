import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../../models/label/label.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../../constants/constants.dart';
import '../../preferences/preference_key.dart';
import 'select.dart';

/// Toggles whether the [labels] are locked.
Future<bool> toggleLockLabels(WidgetRef ref, {required List<Label> labels}) async {
  final lockLabelPreference = PreferenceKey.lockLabel.preferenceOrDefault;
  final anyLocked = labels.any((label) => label.locked);

  // If the lock label setting is enabled and a label was locked, then ask to authenticate
  if (lockLabelPreference && anyLocked) {
    final bool authenticated = await LocalAuthentication().authenticate(localizedReason: l.lock_page_reason_action);

    if (!authenticated) {
      return false;
    }
  }

  final toggled = await ref.read(labelsProvider.notifier).toggleLock(labels);

  exitLabelsSelectionMode(ref);

  return toggled;
}
