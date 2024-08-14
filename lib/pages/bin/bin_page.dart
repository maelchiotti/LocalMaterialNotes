import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/select.dart';
import 'package:localmaterialnotes/common/widgets/notes/notes_list.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// Page displaying the deleted notes.
///
/// Contains:
///   - The list of deleted notes.
///   - The FAB to empty the bin.
class BinPage extends ConsumerStatefulWidget {
  const BinPage();

  @override
  ConsumerState<BinPage> createState() => _BinPageState();
}

class _BinPageState extends ConsumerState<BinPage> {
  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(_interceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(_interceptor);

    super.dispose();
  }

  /// Actions to perform when the back button is intercepted.
  ///
  /// If the selection mode is not active, the route should be popped (closing the app). Otherwise, the navigation mode
  /// should be exited, but the route shouldn't be popped (keeping the app open).
  bool _interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (!isSelectionModeNotifier.value) {
      return false;
    } else {
      exitSelectionMode(ref);

      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const NotesList.bin();
  }
}
