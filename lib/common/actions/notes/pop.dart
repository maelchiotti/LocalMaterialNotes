import '../../constants/constants.dart';

/// Closes the expandable FAB to add a note if it is open.
///
/// Handles both the FAB of the notes page and the one of the label pages.
void closeAddNoteFabIfOpen() {
  for (final fabKey in [addNoteFabKey, labeledAddNoteFabKey]) {
    final fab = fabKey.currentState;
    if (fab != null && fab.isOpen) {
      fab.toggle();
    }
  }
}
