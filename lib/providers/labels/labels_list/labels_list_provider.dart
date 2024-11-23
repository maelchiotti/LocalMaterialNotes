import 'package:collection/collection.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/services/labels/labels_service.dart';
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
}
