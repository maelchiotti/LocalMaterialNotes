import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../utils.dart';

void main() {
  patrolTest('Adds a note using the corresponding FAB', ($) async {
    await $.pumpWidgetAndSettle(await app);

    // Find the FAB to add a note
    expect($(#fabAddNote), findsOne);

    // Add a note
    await $(#fabAddNote).tap();

    // Find the editor app bar, title text field and content text field
    expect($(#appBarEditor), findsOne);
    expect($(#editorTitleTextField), findsOne);
    expect($(#editorContentTextField), findsOne);
  });
}
