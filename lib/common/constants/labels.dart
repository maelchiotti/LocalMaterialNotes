import 'package:flutter/material.dart';
import '../../models/label/label.dart';

// TODO: remove on next Flutter release
// ignore_for_file: deprecated_member_use

/// Labels used when running integration tests.
final integrationTestLabels = <Label>[];

/// Labels used when taking screenshots of the application for the stores.
final screenshotLabels = [
  Label(name: 'Pinned label', colorHex: Colors.red.shade700.value)..pinned = true,
  Label(name: 'Label 1', colorHex: Colors.blue.shade700.value),
  Label(name: 'Label 2', colorHex: Colors.green.shade700.value),
];
