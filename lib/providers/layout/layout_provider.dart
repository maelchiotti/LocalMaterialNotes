import 'package:localmaterialnotes/utils/preferences/layout.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'layout_provider.g.dart';

// ignore_for_file: use_setters_to_change_properties

@Riverpod(keepAlive: true)
class LayoutState extends _$LayoutState {
  @override
  Raw<Layout>? build() {
    return Layout.fromPreference();
  }

  void set(Layout layout) {
    state = layout;
  }
}
