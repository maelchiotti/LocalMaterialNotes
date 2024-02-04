import 'package:fleather/fleather.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'editor_controller_provider.g.dart';

// ignore_for_file: use_setters_to_change_properties

@Riverpod(keepAlive: true)
class EditorController extends _$EditorController {
  @override
  Raw<FleatherController>? build() {
    return null;
  }

  void set(FleatherController fleatherController) {
    state = fleatherController;
  }

  void unset() {
    state = null;
  }
}
