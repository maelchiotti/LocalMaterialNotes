---
name: l10n
description: Add, rename or remove user-facing text in Material Notes (ARB files generated with flutter gen-l10n, translations from Crowdin).
---

# Localizations

- `lib/l10n/translations/app_en.arb` is the source of every key. The other `app_<lang>.arb` files come from Crowdin: never edit them, unless asked, as the next Crowdin sync overwrites them.
- Each key has an `@key` entry with a `description` that says where the text is shown, and a `placeholders` entry for each placeholder, with its `type` and `description`.
- Keys are snake_case and start with their feature, like the existing ones (`settings_`, `dialog_`, `action_`, `tooltip_`, `snack_bar_`, `navigation_`...). Put a new key next to the keys of the same screen.
- Plurals use the ICU syntax: `"{count} {count, plural, one{note} other{notes}}"` with `count` of type `int`.
- `use-escaping` is on: write `''` for an apostrophe (`doesn''t`).
- Use the text with `context.l.<key>` (`common/extensions/build_context_extension.dart`), and `context.fl` for the Flutter material localizations.
- After a change: `flutter gen-l10n`, then `dart analyze --fatal-infos`. `lib/l10n/untranslated.txt` lists the keys missing in each language; it is ignored by git.
- When renaming or removing a key, search `lib` for its old name.

Languages are listed in `common/enums/supported_language.dart` with their completion. Adding a language also needs its Crowdin file and the README list; the maintainer does it at release time.
