import 'package:flutter_test/flutter_test.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/routing/routes/bin/bin_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';
import 'package:patrol/patrol.dart';

import '../utils.dart';

void main() {
  patrolTest('Empties the bin using the corresponding FAB', ($) async {
    await $.pumpWidgetAndSettle(await app);

    // Open the bin page
    BinRoute().go(rootNavigatorKey.currentContext!);
    await $.pumpAndSettle();

    // Find the FAB to empty the bin
    expect($(#fabEmptyBin), findsOne);

    // Find the 1st and 3rd note tiles that should be visible
    expect($(#noteTile0), findsOne);
    expect($(#noteTile10), findsOne);

    // Empty the bin
    await $(#fabEmptyBin).tap();
    await $(#dialogConfirmationConfirmButton).tap();

    // There shouldn't be any notes anymore
    expect($(#noteTile0), findsNothing);
    expect($(#noteTile2), findsNothing);
  });
}
