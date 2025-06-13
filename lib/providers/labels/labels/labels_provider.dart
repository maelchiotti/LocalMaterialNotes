import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/constants/constants.dart';
import '../../../common/extensions/list_extension.dart';
import '../../../models/label/label.dart';
import '../../../models/note/note_status.dart';
import '../../../pages/labels/enums/labels_filter.dart';
import '../../../services/labels/labels_service.dart';
import '../../notes/notes_provider.dart';
import '../labels_list/labels_list_provider.dart';
import '../labels_navigation/labels_navigation_provider.dart';

part 'labels_provider.g.dart';

/// Provider for the labels.
@riverpod
class Labels extends _$Labels {
  final _labelsService = LabelsService();

  @override
  FutureOr<List<Label>> build() => get();

  /// Filters the labels to show the [onlyPinned] ones or the [onlyHidden] ones.
  Future<void> filter(LabelsFilter labelsFilter) async {
    List<Label> filteredLabels = [];

    try {
      filteredLabels = await _labelsService.getAllFiltered(labelsFilter);
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

  /// Toggles whether the [labelsToToggle] are pinned.
  Future<bool> togglePin(List<Label> labelsToToggle) async {
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
      ..removeWhere((label) => labelsToToggle.contains(label))
      ..addAll(labelsToToggle);

    state = AsyncData(labels.sorted());

    await _updateProviders();

    return true;
  }

  /// Toggles whether the [labelsToToggle] are visible.
  Future<bool> toggleVisible(List<Label> labelsToToggle) async {
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
      ..removeWhere((label) => labelsToToggle.contains(label))
      ..addAll(labelsToToggle);

    state = AsyncData(labels.sorted());

    await _updateProviders();

    return true;
  }

  /// Toggles whether the [labelsToToggle] are locked.
  Future<bool> toggleLock(List<Label> labelsToToggle) async {
    for (final label in labelsToToggle) {
      label.locked = !label.locked;
    }

    try {
      await _labelsService.putAll(labelsToToggle);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final labels = (state.value ?? [])
      ..removeWhere((label) => labelsToToggle.contains(label))
      ..addAll(labelsToToggle);

    state = AsyncData(labels.sorted());

    await _updateProviders();

    return true;
  }

  /// Deletes the [labelsToDelete] from the database.
  Future<bool> delete(List<Label> labelsToDelete) async {
    try {
      await _labelsService.deleteAll(labelsToDelete);
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      return false;
    }

    final label = (state.value ?? [])..removeWhere((label) => labelsToDelete.contains(label));

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
      ...?state.value?..forEach((label) {
        label.selected = true;
      }),
    ]);
  }

  /// Unselects all the labels.
  void unselectAll() {
    state = AsyncData([
      ...?state.value?..forEach((label) {
        label.selected = false;
      }),
    ]);
  }

  /// Updates all the providers that use labels.
  Future<void> _updateProviders() async {
    await ref.read(labelsNavigationProvider.notifier).get();
    await ref.read(labelsListProvider.notifier).get();

    await ref.read(notesProvider(status: NoteStatus.available).notifier).get();
    await ref.read(notesProvider(status: NoteStatus.archived).notifier).get();
    await ref.read(notesProvider(status: NoteStatus.deleted).notifier).get();
  }
}
