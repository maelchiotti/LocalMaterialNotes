import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/constants/constants.dart';
import '../../../models/label/label.dart';
import '../../../navigation/navigation_routes.dart';
import '../../../navigation/router.dart';
import '../../../pages/notes/notes_page.dart';
import '../../../services/labels/labels_service.dart';

part 'labels_navigation_provider.g.dart';

/// Provider for the labels.
@Riverpod(keepAlive: true)
class LabelsNavigation extends _$LabelsNavigation {
  final _labelsService = LabelsService();

  @override
  FutureOr<List<Label>> build() => get();

  /// Returns the list of labels.
  Future<List<Label>> get() async {
    List<Label> labels = [];

    try {
      labels = await _labelsService.getAllVisible();
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);
    }

    state = AsyncData(labels.sorted());

    _updateRoutingConfig();

    return labels.sorted();
  }

  /// Updates the [routingConfig] with the labels.
  void _updateRoutingConfig() {
    var dynamicNotesRoute = defaultNotesRoute;
    final notesRoutes = List.of(dynamicNotesRoute.routes);

    final labelsRoutes = (state.value ?? []).map(
      (label) => GoRoute(
        name: NavigationRoute.getLabelRouteName(label),
        path: NavigationRoute.getLabelRoutePath(label),
        builder: (context, state) => NotesPage(label: label),
      ),
    );

    notesRoutes.addAll(labelsRoutes);
    dynamicNotesRoute = GoRoute(
      name: NavigationRoute.notes.name,
      path: NavigationRoute.notes.path,
      builder: (context, state) {
        final label = state.extra as Label?;

        return NotesPage(label: label);
      },
      routes: notesRoutes,
    );

    final newRoutingConfig = RoutingConfig(
      redirect: goRouterRedirect,
      routes: [lockRoute, dynamicNotesRoute, editorRoute],
    );

    routingConfig.value = newRoutingConfig;
  }
}
