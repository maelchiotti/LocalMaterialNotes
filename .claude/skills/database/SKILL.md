---
name: database
description: Change a Material Notes model stored in Isar or exported in backups (notes, note types, labels), with its migration and the backward compatibility of the JSON import.
---

# Database and backup changes

Users keep their notes for years and import old backups: data must never be lost.

## Model

- Notes: `models/note/note.dart` (common fields of the `sealed class Note`) and `models/note/types/*_note.dart` (one `part` and one Isar collection per type). Labels: `models/label/label.dart`.
- Isar annotations: `@Index()` for the fields used in `where()`, `@ignore` for the getters and the fields not stored.
- JSON (`json_serializable`, `field_rename: snake`, `explicit_to_json`): give a new field a `@JsonKey(defaultValue: ...)` so that older backups still import. Use `includeFromJson`/`includeToJson` for the fields not exported.
- Encrypted backups: a new text field of a note is encrypted too, in `encrypted(password)` and `fromJsonEncrypted(json, password)` of each type.
- The getters `contentAsText`, `contentAsMarkdown`, `contentPreview`, `isContentEmpty` must stay right for the Markdown export, the share and the tiles.
- After a change: `dart run build_runner build`.

## Migration

An added nullable field or a field with a default needs no migration. Anything else (moving data, new IDs, changing a type) needs one:

1. Bump the default of `PreferenceKey.databaseVersion`.
2. Add `_migrateToVN()` to `services/migration/migration_service.dart` and call it from `migrateIfNeeded()` when `databaseVersion < N`.
3. Read, transform and put back the notes with their labels, set `databaseVersion` to N, then log with `logger.i`.

Old models stay in `models/deprecated` while a migration reads them, and their schema stays in `Isar.open` in `database_service.dart`. A new collection is added to that list too.

## Import

`services/backup/backup_service.dart` imports every older format: exports without `type` (before 2.0.0, rich text only), encrypted or not, with or without labels and preferences. Keep each path working. Sample exports are in `docs/data` (`export.json`, `export_old.json`, `export_1000_notes.json`): update `export.json` when the format changes, and check by hand that the old ones still import.

The converters of `docs/external_imports` produce this format too: update them when a required field changes.

Then run the `check` skill.
