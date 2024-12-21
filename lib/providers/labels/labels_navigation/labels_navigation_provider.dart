import 'package:collection/collection.dart';
import '../../../common/constants/constants.dart';
import '../../../models/label/label.dart';
import '../../../services/labels/labels_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'labels_navigation_provider.g.dart';

/// Provider for the labels.
@Riverpod(keepAlive: true)
class LabelsNavigation extends _$LabelsNavigation {
  final _labelsService = LabelsService();

  @override
  FutureOr<List<Label>> build() {
    return get();
  }

  /// Returns the list of labels.
  Future<List<Label>> get() async {
    List<Label> labels = [];

    try {
      labels = await _labelsService.getAllVisible();
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);
    }

    state = AsyncData(labels.sorted());

    return labels.sorted();
  }
}
