---
name: release
description: Prepare a new version of Material Notes (version bump, CHANGELOG, fastlane changelogs, languages, descriptions) following RELEASING.md. Use when asked to release or prepare vX.Y.Z.
---

# Prepare a version

Follow `RELEASING.md`. Work on `dev`; the version is published when the `vX.Y.Z` pull request from `dev` is merged into `main`. Never merge into `main` yourself, and never push to `main`.

1. **Version**: in `pubspec.yaml`, bump `version: X.Y.Z+N` with semantic versioning and `N` the previous build number plus one. Bump the Flutter version in `.fvmrc` and `environment.flutter` together when asked.
2. **Dependencies**, when asked: `flutter pub upgrade --major-versions`, then fix the breaking changes and run the `check` skill.
3. **CHANGELOG.md**: a `## X.Y.Z - YYYY-MM-DD` section at the top, Keep a Changelog headings (`### Added`, `### Changed`, `### Fixed`, `### Removed`, `### Miscellaneous`), one short line per user-visible change, written for users.
4. **Fastlane changelogs**: `fastlane/metadata/android/en-US/changelogs/<N*10>.txt` and `fr-FR/changelogs/<N*10>.txt` (build 38 → `380.txt`, the fat APK version code of `android/app/build.gradle`). Upper-case headings (`ADDED`, `CHANGED`, `FIXED`, `REMOVED`, `MISCELLANEOUS`; in French `AJOUTÉ`, `MODIFIÉ`, `CORRIGÉ`, `SUPPRIMÉ`, `DIVERS`), `- ` lines, no trailing newline, at most 500 characters (`docs/google_play/changelogs_max_length.txt`).
5. **Descriptions**, when a feature changes them: `README.md` and `fastlane/metadata/android/*/full_description.yaml`, then `python scripts/generate_full_description.py` to regenerate the `full_description.txt` files.
6. **Languages**: after a Crowdin sync, update the completions in `lib/common/enums/supported_language.dart` and the README list of languages.
7. **Screenshots**: when the UI changed, update `common/constants/notes.dart` and `labels.dart`; the maintainer takes the screenshots with `--dart-define=SCREENSHOTS=true`.
8. Run the `check` skill, then open or update the `vX.Y.Z` pull request from `dev` into `main` with the CHANGELOG section as its description.

The release workflow takes the version from `pubspec.yaml` and the GitHub release notes from the CHANGELOG section of that version: their versions must match.
