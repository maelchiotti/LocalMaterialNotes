# Commands

## Flutter

Generate icons:

```shell
dart run flutter_launcher_icons
```

Generate splash screen:

```shell
dart run flutter_native_splash:create
```

## Tests

All tests:

```shell
patrol test -t integration_test --dart-define=INTEGRATION_TEST=true
```

A specific test:

```shell
patrol test -t integration_test/launch/launch_test.dart --dart-define=INTEGRATION_TEST=true
```

## Release

Generate full descriptions :

```shell
py docs/scripts/generate_full_description.py
```