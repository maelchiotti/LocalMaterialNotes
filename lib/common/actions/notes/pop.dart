import '../../constants/constants.dart';

/// Closes the expandable FAB to add a note if it is open.
void closeAddNoteFabIfOpen() {
  if (addNoteFabKey.currentState != null && addNoteFabKey.currentState!.isOpen) {
    addNoteFabKey.currentState!.toggle();
  }
}
