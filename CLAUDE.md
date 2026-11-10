# Material Notes

Local, private note-taking app for Android, in Flutter (`com.maelchiotti.localmaterialnotes`, AGPL-3.0). The app has no internet permission: never add a feature that needs the network.

Released on GitHub, the Play Store, F-Droid and IzzyOnDroid. Translations come from Crowdin.

## Stack

- Flutter and Dart pinned in `.fvmrc` and `pubspec.yaml` (`environment.flutter`). Locally, run Flutter through `fvm`.
- State: Riverpod 3 with code generation (`@riverpod`), plus global `ValueNotifier`s in `providers/notifiers/notifiers.dart`.
- Database: Isar (`isar_community`), one collection per note type. Native libraries are built from the `.isar` submodule for F-Droid (`scripts/isar`).
- Navigation: go_router (`navigation/router.dart`, routes in `navigation_routes.dart`).
- Editors: fleather (rich text), `flutter_markdown_plus` (Markdown), `flutter_checklist` (checklist), `TextField` (plain text).
- Settings UI: `settings_tiles`. `flag_secure` sets `FLAG_SECURE`.

`settings_tiles`, `flutter_checklist` and `flag_secure` are the maintainer's own packages (`maelchiotti/<name>`), used from pub.dev. To try a change of one of them in the app, add a `dependency_overrides` with a `path` to its checkout, and never commit it: publish the package, then bump its version in `pubspec.yaml`.

## Commands

The `*.g.dart` files and `lib/l10n/app_localizations/` are generated and not committed: generate them before analyzing or building.

- Install: `flutter pub get`
- Generate code: `dart run build_runner build` (models, providers). Use `watch` while developing.
- Generate localizations: `flutter gen-l10n`
- Analyze: `dart analyze --fatal-infos` (CI, after both generations)
- Format: `dart format -l 120 <files>` (CI: `dart format -l 120 --set-exit-if-changed .` on a checkout without the generated files, so format only the committed files: `dart format -l 120 $(git ls-files '*.dart')`)
- Run: `flutter run` (debug), `--dart-define=SCREENSHOTS=true` to fill the database with the screenshot notes of `common/constants/notes.dart` and `labels.dart`.
- Build: `flutter build apk --release` (`--split-per-abi` for the per-ABI APKs). Needs `android/key.properties` and the keystore, which are only in the CI.

There are no automated tests. The `check` skill runs every check.

## Architecture

`pages` (UI) → `common/actions` (user actions: confirmation, provider call, snack bar with undo) → `providers` (state) → `services` (database) → `models`.

- `models/note/note.dart`: `sealed class Note` with the parts `types/plain_text_note.dart`, `markdown_note.dart`, `rich_text_note.dart`, `checklist_note.dart`. Each type is an Isar `@Collection()` and a `@JsonSerializable()`. A note is available, archived or deleted (`NoteStatus`), never archived and deleted at once. `id` is a UUID, `isarId` its hash.
- `models/label/label.dart`: labels, linked to the notes by `IsarLinks`.
- `services/*_service.dart`: singletons (`factory X() => _singleton`) with `ensureInitialized()`, called in order from `main.dart` and `DatabaseService`. `NotesService` queries the four collections and concatenates the results.
- `services/migration/migration_service.dart`: database migrations, keyed by `PreferenceKey.databaseVersion`.
- `services/backup`: JSON import and export (optionally encrypted with `EncryptionUtils`), Markdown export in a ZIP, automatic export. The JSON format must stay importable by every later version.
- `providers/notes/notes_provider.dart`: `notesProvider(status:, label:)`, `keepAlive`. A method updates the database through the service, then the state, then the other providers that show the same notes (unlabeled, labeled). It catches and logs the errors and returns `false`.
- `common/preferences`: `PreferenceKey` enum (default value, `secure`, `backup`), read with `preferenceOrDefault`, written with `set`. Preferences with choices are enums in `preferences/enums` with a `fromPreference()` factory that resets a malformed value. `WatchedPreferences` holds the ones that rebuild the whole app.
- `common/constants`: `Paddings`, `Sizes`, `Separator`; the global `logger` (`AppLogger`, console in debug, file in release); `rootNavigatorKey`.

## Code style

- Formatter width 120. Relative imports inside `lib` (`prefer_relative_imports`).
- Every public member has a `///` doc comment (`public_member_api_docs`). Enums of preferences and routes use `// ignore_for_file: public_member_api_docs`.
- Control bodies on their own line, always with braces. No unawaited future: `await` it or wrap it in `unawaited(...)`.
- Text shown to the user goes through `context.l.<key>` (`BuildContextExtension`), never a literal string. See the `l10n` skill.
- Log caught exceptions with `logger.e(exception.toString(), exception, stackTrace)`; warnings with `logger.w`.
- Use the existing `askForConfirmation`, `SnackBarUtils().show` and placeholders (`EmptyPlaceholder`, `ErrorPlaceholder`, `LoadingPlaceholder`) instead of new ones.
- Use `EdgeInsetsDirectional` through `Paddings`, so that right-to-left languages are laid out correctly.

## Git and releases

- `main` only receives releases. Never push to `main`, and never merge into it a pull request other than a release.
- Work goes into a version branch named `vX.Y.Z`. By default it is the next minor version (`2.2.2` → `v2.3.0`); create it from `main` if it doesn't exist yet. When the changes grow (a breaking change, a major feature), rename the branch to bump `Y` or `X`, and keep `pubspec.yaml`, the CHANGELOG and the open pull requests in line with it.
- Each change has a GitHub issue, a branch `fix/<issue>_<slug>` or `feat/<issue>_<slug>` from the version branch, and a pull request into the version branch titled `[<issue>] <Title>`.
- Every issue and pull request has a label for its kind: `bug`, `enhancement`, `localization`, `documentation`, `tests` or `style`, and `release` for a version pull request. A pull request gets the label of its issue.
- The release is a pull request from the version branch into `main`, titled `vX.Y.Z` and squash-merged. Every push to `main` runs the release workflow (Play Store and GitHub release). The `release` skill prepares it.
- CI on each push: analyze and format (`.github/workflows/dart.yaml`). On each pull request: build the Isar libraries and the APK (`build.yaml`).

## Skills

- `check`: every check before saying a change is done.
- `l10n`: add or change user-facing text.
- `preference`: add a setting.
- `database`: change a model stored in Isar or exported in backups.
- `release`: prepare a new version.
