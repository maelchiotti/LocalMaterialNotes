import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/label/label.dart';
import '../../../providers/labels/labels/labels_provider.dart';
import '../../extensions/build_context_extension.dart';
import '../authentication.dart';
import 'select.dart';

/// Toggles whether the [labels] are locked.
Future<bool> toggleLockLabels(BuildContext context, WidgetRef ref, {required List<Label> labels}) async {
  // If required, ask for authentication
  final requiresAuthentication = labels.any((label) => label.requiresAuthentication);
  if (requiresAuthentication) {
    final authenticated = await authenticate(context, reason: context.l.lock_page_reason_action);

    if (!authenticated) {
      return false;
    }
  }

  final toggled = await ref.read(labelsProvider.notifier).toggleLock(labels);

  exitLabelsSelectionMode(ref);

  return toggled;
}
