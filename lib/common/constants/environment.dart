/// Environment parameters that can be provided with `--dart-define`.
class Environment {
  /// Whether the application should be used to take screenshots for the stores.
  static const integrationTest = bool.fromEnvironment('INTEGRATION_TEST');

  /// Whether the application should be used to take screenshots for the stores.
  static const screenshots = bool.fromEnvironment('SCREENSHOTS');
}
