# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.1.1 - 2024-03-03

### Added

- Export notes as Markdown
- Show a separator between the notes (toggleable)

### Removed

- Remove the app lock feature (most recent Android devices have a more stable, built-in identical functionality)

### Fixed

- Disable the black theme setting tile while in light theme
- Automatically sort in descending order when sorting by date, and in ascending order when sorting by title (the order can still be manually changed afterwards)

## 1.1.0 - 2024-02-18

### Added

- Authentication on application launch
- Add tagline and about text in the info section of the settings

### Changed

- Revert to using default page transitions
- Automatically restart the app when changing the language
- Use the Storage Access Framework to handle file I/O and thus remove storage permissions

### Fixed

- Localize the welcome note
- Going back from the editor after adding a note from the quick action when the editor was already opened on an other note correctly goes back to the notes list

## 1.0.1 - 2024-02-10

### Added

- Welcome note when first launching the app

### Fixed

- System navigation bar transparency and the padding at the bottom of the settings page

## 1.0.0 - 2024-02-07

Initial release.