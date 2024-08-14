import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../utils.dart';

void main() {
  patrolTest(
    'Initializes and launches the app',
    ($) async {
      await $.pumpWidgetAndSettle(await appInitialized);

      expect($(#appBarNotes), findsOne);
    },
  );
}
