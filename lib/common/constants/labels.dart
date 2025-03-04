import 'package:flutter/material.dart';

import '../../models/label/label.dart';

/// Labels used when running integration tests.
final integrationTestLabels = <Label>[];

/// Labels used when taking screenshots of the application for the stores.
final screenshotLabels = [
  Label(name: 'Pinned label', colorHex: Colors.red.shade700.toARGB32())..pinned = true,
  Label(name: 'Label 1', colorHex: Colors.blue.shade700.toARGB32()),
  Label(name: 'Label 2', colorHex: Colors.green.shade700.toARGB32()),
];
