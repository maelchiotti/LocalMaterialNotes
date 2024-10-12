// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shell_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $shellRoute,
    ];

RouteBase get $shellRoute => ShellRouteData.$route(
      factory: $ShellRouteExtension._fromState,
      routes: [
        GoRouteData.$route(
          path: '/notes',
          factory: $NotesRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'editor',
              factory: $NotesEditorRouteExtension._fromState,
            ),
          ],
        ),
        GoRouteData.$route(
          path: '/bin',
          factory: $BinRouteExtension._fromState,
        ),
        GoRouteData.$route(
          path: '/settings',
          factory: $SettingsRouteExtension._fromState,
          routes: [
            GoRouteData.$route(
              path: 'appearance',
              factory: $SettingsAppearanceRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'behavior',
              factory: $SettingsBehaviorRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'editor',
              factory: $SettingsEditorRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'backup',
              factory: $SettingsBackupRouteExtension._fromState,
            ),
            GoRouteData.$route(
              path: 'about',
              factory: $SettingsAboutRouteExtension._fromState,
            ),
          ],
        ),
      ],
    );

extension $ShellRouteExtension on ShellRoute {
  static ShellRoute _fromState(GoRouterState state) => ShellRoute();
}

extension $NotesRouteExtension on NotesRoute {
  static NotesRoute _fromState(GoRouterState state) => NotesRoute();

  String get location => GoRouteData.$location(
        '/notes',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $NotesEditorRouteExtension on NotesEditorRoute {
  static NotesEditorRoute _fromState(GoRouterState state) => NotesEditorRoute(
        readOnly: _$convertMapValue('read-only', state.uri.queryParameters, _$boolConverter),
        autoFocus: _$convertMapValue('auto-focus', state.uri.queryParameters, _$boolConverter),
      );

  String get location => GoRouteData.$location(
        '/notes/editor',
        queryParams: {
          if (readOnly != null) 'read-only': readOnly!.toString(),
          if (autoFocus != null) 'auto-focus': autoFocus!.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $BinRouteExtension on BinRoute {
  static BinRoute _fromState(GoRouterState state) => BinRoute();

  String get location => GoRouteData.$location(
        '/bin',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsRouteExtension on SettingsRoute {
  static SettingsRoute _fromState(GoRouterState state) => SettingsRoute();

  String get location => GoRouteData.$location(
        '/settings',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsAppearanceRouteExtension on SettingsAppearanceRoute {
  static SettingsAppearanceRoute _fromState(GoRouterState state) => SettingsAppearanceRoute();

  String get location => GoRouteData.$location(
        '/settings/appearance',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsBehaviorRouteExtension on SettingsBehaviorRoute {
  static SettingsBehaviorRoute _fromState(GoRouterState state) => SettingsBehaviorRoute();

  String get location => GoRouteData.$location(
        '/settings/behavior',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsEditorRouteExtension on SettingsEditorRoute {
  static SettingsEditorRoute _fromState(GoRouterState state) => SettingsEditorRoute();

  String get location => GoRouteData.$location(
        '/settings/editor',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsBackupRouteExtension on SettingsBackupRoute {
  static SettingsBackupRoute _fromState(GoRouterState state) => SettingsBackupRoute();

  String get location => GoRouteData.$location(
        '/settings/backup',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

extension $SettingsAboutRouteExtension on SettingsAboutRoute {
  static SettingsAboutRoute _fromState(GoRouterState state) => SettingsAboutRoute();

  String get location => GoRouteData.$location(
        '/settings/about',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) => context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}
