import 'package:collection/collection.dart';
import '../../../common/constants/constants.dart';
import '../../../models/label/label.dart';
import '../../../services/labels/labels_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'labels_list_provider.g.dart';

/// Provider for the labels.
@Riverpod(keepAlive: true)
class LabelsList extends _$LabelsList {
  final _labelsService = LabelsService();

  @override
  FutureOr<List<Label>> build() {
    return get();
  }

  /// Returns the list of labels.
  Future<List<Label>> get() async {
    List<Label> labels = [];

    try {
      labels = await _labelsService.getAll();
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);
    }

    state = AsyncData(labels.sorted());

    return labels.sorted();
  }

  /// Returns the label with the [name].
  Label getByName(String name) {
    assert(state.value != null, 'The value of the labels list provider is null');

    return state.value!.firstWhere((label) => label.name == name);
  }
}
