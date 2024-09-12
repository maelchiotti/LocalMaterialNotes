import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/routing/routes/notes/notes_route.dart';
import 'package:localmaterialnotes/routing/routes/shell/shell_route.dart';

/// Application's router.
final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: NotesRoute().location,
  routes: $appRoutes,
);
