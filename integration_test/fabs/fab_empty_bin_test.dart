import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../utils.dart';

void main() {
  patrolTest('Empties the bin using the corresponding FAB', ($) async {
    await $.pumpWidgetAndSettle(await app);
    await openBin($);

    // Find the FAB to empty the bin
    expect($(#fabEmptyBin), findsOne);

    // Find the 1st and 3rd note tiles that should be visible
    expect($(#noteTile0), findsOne);
    expect($(#noteTile10), findsOne);

    // Empty the bin
    await $(#fabEmptyBin).tap();
    await $(#dialogConfirmButton).tap();

    // There shouldn't be any notes anymore
    expect($(#noteTile0), findsNothing);
    expect($(#noteTile2), findsNothing);
  });
}
