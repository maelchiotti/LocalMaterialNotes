import 'package:collection/collection.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/list_extension.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/providers/labels/labels_list/labels_list_provider.dart';
import 'package:localmaterialnotes/services/labels/labels_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../labels_navigation/labels_navigation_provider.dart';

part 'labels_provider.g.dart';

/// Provider for the labels.
@Riverpod()
class Labels extends _$Labels {
  final _labelsService = LabelsService();

  @override
  FutureOr<List<Label>> build() {
    return get();
  }

  Future<void> _updateProviders() async {
    await ref.read(labelsNavigationProvider.notifier).get();
    await ref.read(labelsListProvider.notifier).get();
  }

  /// Filters the labels to show the [onlyPinned] ones or the [onlyHidden] ones.
  Future<void> filter(bool onlyPinned, bool onlyHidden) async {
    List<Label> filteredLabels = [];

    try {
      filteredLabels = await _labelsService.getAllFiltered(onlyPinned, onlyHidden);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);
    }

    state = AsyncData(filteredLabels.sorted());
  }

  /// Returns the list of labels.
  Future<List<Label>> get() async {
    List<Label> labels = [];

    try {
      labels = await _labelsService.getAll();
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);
    }

    return labels.sorted();
  }

  /// Saves the [editedLabel] to the database.
  Future<bool> edit(Label editedLabel) async {
    try {
      await _labelsService.put(editedLabel);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final labels = (state.value ?? [])..addOrUpdate(editedLabel);

    state = AsyncData(labels.sorted());

    await _updateProviders();

    return true;
  }

  /// Toggles the pin status of the [label] in the database.
  Future<bool> togglePin(Label label) async {
    label.pinned = !label.pinned;
    if (label.pinned) {
      label.visible = true;
    }

    return await edit(label);
  }

  /// Toggles the pin status of the [labelsToToggle] in the database.
  Future<bool> togglePinAll(List<Label> labelsToToggle) async {
    for (final label in labelsToToggle) {
      label.pinned = !label.pinned;
      if (label.pinned) {
        label.visible = true;
      }
    }

    try {
      await _labelsService.putAll(labelsToToggle);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final labels = (state.value ?? [])
      ..removeWhere(
        (label) => labelsToToggle.contains(label),
      )
      ..addAll(labelsToToggle);

    state = AsyncData(labels.sorted());

    await _updateProviders();

    return true;
  }

  /// Toggles the visible status of the [label] in the database.
  Future<bool> toggleVisible(Label label) async {
    label.visible = !label.visible;
    if (!label.visible) {
      label.pinned = false;
    }

    return await edit(label);
  }

  /// Toggles the visible status of the [labelsToToggle] in the database.
  Future<bool> toggleVisibleAll(List<Label> labelsToToggle) async {
    for (final label in labelsToToggle) {
      label.visible = !label.visible;
      if (!label.visible) {
        label.pinned = false;
      }
    }

    try {
      await _labelsService.putAll(labelsToToggle);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final labels = (state.value ?? [])
      ..removeWhere(
        (label) => labelsToToggle.contains(label),
      )
      ..addAll(labelsToToggle);

    state = AsyncData(labels.sorted());

    await _updateProviders();

    return true;
  }

  /// Deletes the [labelToDelete] from the database.
  Future<bool> delete(Label labelToDelete) async {
    try {
      await _labelsService.delete(labelToDelete);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    state = AsyncData(
      (state.value ?? [])..remove(labelToDelete),
    );

    await _updateProviders();

    return true;
  }

  /// Deletes the [labelsToDelete] from the database.
  Future<bool> deleteAll(List<Label> labelsToDelete) async {
    try {
      await _labelsService.deleteAll(labelsToDelete);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final label = (state.value ?? [])
      ..removeWhere(
        (label) => labelsToDelete.contains(label),
      );

    state = AsyncData(label);

    await _updateProviders();

    return true;
  }

  /// Selects the [labelToSelect].
  void select(Label labelToSelect) {
    state = AsyncData([
      for (final Label label in state.value ?? []) label == labelToSelect ? (labelToSelect..selected = true) : label,
    ]);
  }

  /// Unselects the [labelToSelect].
  void unselect(Label labelToSelect) {
    state = AsyncData([
      for (final Label label in state.value ?? []) label == labelToSelect ? (labelToSelect..selected = false) : label,
    ]);
  }

  /// Selects all the labels.
  void selectAll() {
    state = AsyncData([
      ...?state.value
        ?..forEach((label) {
          label.selected = true;
        }),
    ]);
  }

  /// Unselects all the labels.
  void unselectAll() {
    state = AsyncData([
      ...?state.value
        ?..forEach((label) {
          label.selected = false;
        }),
    ]);
  }
}
