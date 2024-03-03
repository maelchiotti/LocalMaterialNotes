<div align="center">

![Platforms](https://img.shields.io/badge/Platforms-Android-blue)
[![Style](https://img.shields.io/badge/Style-lint-blue)](https://pub.dev/packages/lint)

[![License](https://img.shields.io/github/license/maelchiotti/LocalMaterialNotes)](https://github.com/maelchiotti/LocalMaterialNotes/blob/main/LICENSE)
[![Releases](https://img.shields.io/github/v/release/maelchiotti/LocalMaterialNotes)](https://github.com/maelchiotti/LocalMaterialNotes/releases)
[![Issues](https://img.shields.io/github/issues/maelchiotti/LocalMaterialNotes)](https://github.com/maelchiotti/LocalMaterialNotes/issues)

</div>

# Local Material Notes

Simple, local, material design notes.

<div align="center">
  <img alt="Screenshot of the notes list" src="assets/screenshots/v1.1.0_notes.jpg" width="24%">
  <img alt="Screenshots of the note editor" src="assets/screenshots/v1.1.0_editor.jpg" width="24%">
  <img alt="Screenshot of the bin" src="assets/screenshots/v1.1.0_bin.jpg" width="24%">
  <img alt="Screenshot of the settings" src="assets/screenshots/v1.1.0_settings_1.jpg" width="24%">
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

- English: 100%
- French: 100%

## Alternatives

- [Simplenote](https://simplenote.com) for simple text notes that are synchronized over your devices and available on several platforms. Also provides extra features such as tags, history and collaboration.

## Credits

- [Material Design Icons](https://github.com/google/material-design-icons) for the [notes](https://fonts.google.com/icons?selected=Material+Symbols+Outlined:notes) icon used for the logo.

---

## Enhancements

- Highlight search terms in the title/content of the list tiles in the search view: [Highlightable](https://pub.dev/packages/highlightable) could work great for this, but if the text to highlight isn't in the first 3 lines then it is not shown.
- Better search: Improve the search to be more effective than the current `contains()`.
