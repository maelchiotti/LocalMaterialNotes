# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.10.0 - 2024-12-21

### Added

- Drastically better search performance with typo tolerance
- Setting to make the titles of the notes bigger
- Czech translation

### Changed

- Layout and swipe action preferences not updating correctly
- Going back from a label page or the Manage labels page goes back to the notes list
- Organization of some settings

### Fixed

- Last edited date of a note being changed when the note is pinned or unpinned
- Black screen when deleting or restoring a note from the editor
- Malformed URL when opening a link from the editor

## 1.9.1 - 2024-12-11

### Fixed

- Crash when loading the theming preference

## 1.9.0 - 2024-12-11

### Added

- Backup labels
- Backup settings
- Python script to convert exports from DNotes (see GitHub)
- Hindi translation

### Changed

- Moved the button to change the editor mode to the app bar

### Fixed

- Labels count shown in about dialog when labels are disabled
- Wrong color in the label color picker when editing a label
- Going back after selecting labels closes the app
- Missing message if no labels exist when trying to select the labels of a note
- Ask for confirmation when deleting labels
- Missing explanation on what disabling labels does
- Sort order reset when going from creation date to edition date (and vice-versa)
- Wrong texts on some buttons

## 1.8.2 - 2024-11-13

### Fixed

- Error at startup because of the ascending sorting setting

## 1.8.1 - 2024-11-13

### Fixed

- Crash at startup because of the sorting method setting

## 1.8.0 - 2024-11-23

### Added

- Ability to categorize the notes with labels
- Allow to sort the notes by their creation date
- Allow to use a white text in dark theme
- Polish translation

### Changed

- Improve logs
- Move accessibility settings to their own page

### Fixed

- Failure to add a note via the share action of the quick action

## 1.7.2 - 2024-10-19

### Added

- Python script to convert Samsung Notes exports to a format compatible with Material Notes (see the GitHub repository)
- Ability to copy the logs to the clipboard and to export them to a text file

### Changed

- Improve the style of the settings tiles

### Fixed

- Using the system back button or back gesture after opening a dialog, sheet or menu closes the app
- Auto export directory picker fails when choosing a directory that is not at the root of the storage
- JSON export file using the .txt extension instead of .json
- Buttons in the editor app bar not disabled in reading mode
- Button to toggle between editing and reading mode not hidden for deleted notes

## 1.7.1 - 2024-10-11

### Added

- Error page shown when a page fails to load, with the ability to copy and export the error logs

### Improved

- Reliability of the automatic exports

### Fixed

- Value of the setting on the settings tiles not using a subdued color when disabled
- Small note pinned icon on the notes tiles
- Small application icon

### Removed

- `READ_EXTERNAL_STORAGE` and `WRITE_EXTERNAL_STORAGE` permissions that were added by mistake

## 1.7.0 - 2024-10-05

### Added

- Toolbar button to add a link to the selected text
- Button to toggle the editor between editing mode and reading mode
- Setting to open the editor in reading mode by default
- Copy to clipboard menu and swipe action
- Share swipe action
- Live preview when selecting the text scaling

### Changed

- Settings values display

### Fixed

- Text scaling popup having a wrong title

## 1.6.0 - 2024-09-06

### Added

- Release on F-Droid
- Setting to choose the auto backup directory
- Setting to only show the titles of the notes (can be disabled in the search view)
- Setting to focus the title instead of the content when creating a new note
- Setting to disable the subdued color of the notes content preview
- Setting to change the text scaling
- Chinese simplified translation

### Fixed

- Search view is not black in black theme mode
- Failure to set the refresh rate on devices running Android below version 6
- Failure to get the write permission when writing export files

## 1.5.2 - 2024-08-16

### Added

- Portuguese translation

### Fixed

- Automatic export settings tiles not updating after disabling automatic export
- Notes sorted by their created time instead of their edited time
- Focus on the note content not requested when the title is validated
- Typos

## 1.5.1 - 2024-08-07

### Fixed

- Exiting the editor with the device back button or the back gesture (not the app back button) causes the content of the note to be displayed in any other note opened afterwards
- Special characters incorrectly decoded when importing a JSON file

## 1.5.0 - 2024-08-06

### Added

- Auto JSON backup
- JSON backup encryption
- Settings to customize the swipe actions
- Setting to hide the app from recent apps and prevent screenshots
- Setting to show the checklist button in the toolbar if not shown in the app bar
- Enable high refresh rate
- Russian translation
- Show translations completion as a percentage

### Changed

- New settings page layout that divides settings into separate pages
- Disable undo/redo buttons in the editor's app bar if they can't be used
- Enable swipe actions in grid mode

### Fixed

- Incorrect corner radius and background color of the notes tiles
- Keyboard opening when toggling a checkbox
- Keyboard popping back up after using the back gesture
- App closing when going back while the selection mode is active instead of exiting it
- Strings inconsistencies

### Removed

- Swipe actions in the bin

## 1.4.0 - 2024-06-27

### Added

- Spanish translation
- Toggleable background for notes tiles

### Changed

- Drastically improved the speed of editing/deleting multiple notes
- Use a less vibrant color for the editor toolbar

### Fixed

- Going back from the licences list doesn't close the page
- Going back from the editor page while the menu is open goes back to the notes list instead of closing the menu
- Empty note still shown until the notes list is refreshed
- Devices using a system RTL language not having the app use the RTL layout
- Slightly wrong icon size on the splash screen for Android 12+ devices

## 1.3.0 - 2024-05-22

### Added

- Release on IzzyOnDroid
- Grid view
- Advanced text formatting
- Undo/redo while editing
- Setting to toggle advanced text formatting
- Setting to toggle undo/redo buttons
- Setting to toggle checklists button

### Removed

- "Untitled note" label

### Changed

- Improve the search precision
- Improve markdown export (support advanced text formatting and export each note to a separate file)
- Going back from the settings closes the application instead of going back to the previous page (if any)

### Fixed

- Note preview shown even if empty
- List of notes not updating correctly
- Notes not sorted after being updated
- RTL not supported for paddings

## 1.2.0 - 2024-04-15

### Added

- Turkish translation
- Adaptive and monochrome icons
- Hint text in the note content text field

### Removed

- Distracting transition between the notes list and the note editor

### Changed

- An empty note will now be automatically deleted
- Use radio buttons where appropriate in the settings dialogs
- Use floating snack bars

### Fixed

- App crashing when using the quick action to add a note if the app was closed, or opened but not on the notes list
- Focus being reset in the note content text field
- Drawer openable on the editor page
- Selection mode note exited when adding a note
- Tiles background color not scrolling with the tile when scrolling the notes list in selection mode
- FAB padding

## 1.1.1 - 2024-03-03

### Added

- Export notes as Markdown
- Show a separator between the notes (toggleable)

### Changed

- Automatically sort in descending order when sorting by date, and in ascending order when sorting by title (the order can still be manually changed afterwards)

### Removed

- Remove the app lock feature (most recent Android devices have a more stable, built-in identical functionality)

### Fixed

- Black theme setting tile not disabled while in light theme

## 1.1.0 - 2024-02-18

### Added

- Authentication on application launch
- Add tagline and about text in the info section of the settings

### Changed

- Revert to using default page transitions
- Automatically restart the app when changing the language
- Use the Storage Access Framework to handle file I/O and thus remove storage permissions

### Fixed

- Welcome note not localized
- Going back from the editor after adding a note from the quick action when the editor was already opened on an other does not go back to the notes list

## 1.0.1 - 2024-02-10

### Added

- Welcome note when first launching the app

### Fixed

- System navigation bar transparency
- Padding at the bottom of the settings page

## 1.0.0 - 2024-02-07

Initial release.
