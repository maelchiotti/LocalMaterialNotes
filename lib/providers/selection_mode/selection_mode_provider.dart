import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection_mode_provider.g.dart';

@Riverpod(keepAlive: true)
class SelectionMode extends _$SelectionMode {
  @override
  bool build() {
    return false;
  }

  void enterSelectionMode() {
    state = true;
  }

  void exitSelectionMode() {
    state = false;
  }
}
