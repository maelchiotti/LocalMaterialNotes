import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../utils.dart';

void main() {
  patrolTest(
    'Initializes and launches the app',
    ($) async {
      await $.pumpWidgetAndSettle(await app);

      // Find the notes page and its app bar as is the default page when launching the app
      expect($(#pageNotes), findsOne);
      expect($(#appBarNotes), findsOne);
    },
  );
}
