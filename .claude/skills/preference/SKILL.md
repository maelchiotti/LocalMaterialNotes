---
name: preference
description: Add or change a setting of Material Notes (PreferenceKey, preference enum, settings page tile, backup of the preferences).
---

# New or changed setting

Read a similar setting first, for example `labelSwipeRightAction` in `settings_labels_page.dart`, and copy its shape.

1. **Key**: add an entry to `common/preferences/preference_key.dart`, in its section, with its type and default value: `myPreference<bool>(false)`.
   - `secure: true` for a secret (stored with `flutter_secure_storage`, read with `preferenceOrDefaultSecure`, only `String`).
   - `backup: false` when the value must not be exported and imported with the notes (device-specific: paths, locks, passwords, dates).
   - Stored types are `bool`, `int`, `double`, `String` and `List<String>` only.
2. **Choices**: for a value with choices, add an enum in `common/preferences/enums` stored by its `name`, with a `fromPreference()` factory that resets a malformed value to the default (see `sort_method.dart`), and a `title(BuildContext)` for the UI.
3. **Tile**: add it to the settings page of its section (`pages/settings/pages/settings_*_page.dart`) with a `settings_tiles` widget: `SettingSwitchTile`, `SettingSingleOptionTile.detailed`, `SettingSliderTile`... with `SettingTileIcon`, a title, a description and a `SettingTileValue` when it shows a value. The handler awaits `PreferenceKey.x.set(value)` then calls `setState`.
4. **Whole-app effect**: if the setting changes the theme, the font, the scaling or the layout, add it to `WatchedPreferences` and update `preferencesProvider` from the handler.
5. **Texts**: title, description and choices with the `l10n` skill (`settings_<name>`, `settings_<name>_description`).
6. **Read it** where it applies with `PreferenceKey.x.preferenceOrDefault`.

Renaming or removing a key: the old value stays on the devices and in old backups. The import ignores unknown keys with a warning, so a removed key is safe; a renamed key loses the user's value unless you migrate it.

Then run the `check` skill.
