---
name: check
description: Run every check of Material Notes (code generation, format, analyze, build when native or dependency changes) and fix what fails. Use before saying a change is done.
---

# Checks

Run each step and fix every failure before moving on. Report the result of each step.

1. Generate: `dart run build_runner build`, then `flutter gen-l10n`. Both must succeed without warnings about the changed files.
2. Format the committed files: `dart format -l 120 $(git ls-files '*.dart')`, plus the new files not yet tracked. Never commit a `*.g.dart` file.
3. Analyze: `dart analyze --fatal-infos`. The CI fails on infos too.
4. When `pubspec.yaml`, `android/` or a native plugin changed, and the Android SDK is available: `flutter build apk --debug`. Without the SDK, say that the build was not checked.

There are no automated tests: describe what to try by hand in the app (screens, note types, archived and deleted notes, backup and import) for the changed behavior.

Then re-read the diff against `CLAUDE.md`:

- every public member has a `///` doc comment;
- relative imports inside `lib`;
- no literal user-facing string (`l10n` skill);
- the four note types and the three note statuses are all handled;
- a change to a stored or exported model follows the `database` skill.

Never add `// ignore:` unless the existing code already does it in the same situation.
