import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/select.dart';
import 'package:localmaterialnotes/common/widgets/notes_list.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

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

  bool _interceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (!isSelectionModeNotifier.value) {
      return false;
    }

    exitSelectionMode(ref);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return const NotesList.bin();
  }
}
