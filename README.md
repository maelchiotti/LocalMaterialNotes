<div align="center">

![Platforms](https://img.shields.io/badge/Platforms-Android-blue)
[![Style](https://img.shields.io/badge/Style-lint-blue)](https://pub.dev/packages/lint)

[![License](https://img.shields.io/github/license/maelchiotti/LocalMaterialNotes)](https://github.com/maelchiotti/LocalMaterialNotes/blob/main/LICENSE)
[![Releases](https://img.shields.io/github/v/release/maelchiotti/LocalMaterialNotes)](https://github.com/maelchiotti/LocalMaterialNotes/releases)
[![Issues](https://img.shields.io/github/issues/maelchiotti/LocalMaterialNotes)](https://github.com/maelchiotti/LocalMaterialNotes/issues)

[<img alt="Get it on Google Play" src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" width="256">](https://play.google.com/store/apps/details?id=com.maelchiotti.localmaterialnotes)
[<img alt="Get it on GitHub" src="https://raw.githubusercontent.com/Kunzisoft/Github-badge/main/get-it-on-github.png" width="256">](https://github.com/maelchiotti/LocalMaterialNotes/releases/latest)

</div>

# Local Material Notes

Simple, local, material design notes.

<div align="center">
  <img alt="Screenshot of the notes list" src="assets/screenshots/latest_notes.jpg" width="24%">
  <img alt="Screenshots of the note editor" src="assets/screenshots/latest_editor.jpg" width="24%">
  <img alt="Screenshot of the bin" src="assets/screenshots/latest_bin.jpg" width="24%">
  <img alt="Screenshot of the settings" src="assets/screenshots/latest_settings_1.jpg" width="24%">
</div>

<div align="center">
  <img alt="Screenshot of the notes list in selection mode" src="assets/screenshots/latest_notes_selection.jpg" width="24%">
  <img alt="Screenshots of the search feature" src="assets/screenshots/latest_search.jpg" width="24%">
  <img alt="Screenshot of the notes list in the dark mode with dynamic theming" src="assets/screenshots/latest_theme_dynamic_dark.jpg" width="24%">
  <img alt="Screenshot of the notes list in the light mode with dynamic theming" src="assets/screenshots/latest_theme_dynamic_light.jpg" width="24%">
</div>

## Features

### Take notes

- Write text notes (title + content)
- Add checklists along the normal text
- Use the quick action from your home screen to quickly add a note

### Organize

- Search though your notes
- Sort your notes by date or title, in ascending or descending order
- Pin your notes
- Recover your deleted notes from the bin

### Share & backup

- Share text from other applications to add it directly to a note
- Share your notes as text
- Export your notes as JSON and import them back
- Export your notes as Markdown

### Protect

- Never worry about how your data is handled, as it never leaves your device because the application doesn't have any internet permissions

### Customize

- Choose your language (see the [supported ones](#supported-languages))
- Choose your theme (light, dark or black)
- Choose if you want your theme to be dynamic (use colors from your background)

## Screenshots

See more screenshots [here](assets/screenshots).

## Supported languages

- English
- French
- Turkish

To improve or add support for a language, please see [CONTRIBUTING.md](CONTRIBUTING.md#localization).

## Credits

- [Material Design Icons](https://github.com/google/material-design-icons) for the [notes](https://fonts.google.com/icons?selected=Material+Symbols+Outlined:notes) icon used for the logo.
- [Material Files](https://github.com/zhanghai/MaterialFiles) for the general design inspiration, and especially the logo and its color.
- [Simplenote](https://simplenote.com) for the general layout of the app and its basic features.

### Localization

- Turkish: [xe1st](https://github.com/xe1st).

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Enhancements

- Highlight search terms in the title/content of the list tiles in the search view: [Highlightable](https://pub.dev/packages/highlightable) could work great for this, but if the text to highlight isn't in the first 3 lines then it is not shown.
- Better search: Improve the search to be more effective than the current `contains()`.
