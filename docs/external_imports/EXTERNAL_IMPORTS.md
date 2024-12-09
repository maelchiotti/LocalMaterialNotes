# External imports

Python scripts are available to convert export from other note-taking apps to the format used by Material Notes.

## Supported apps

### D Notes

The file to use is the ZIP file exported from the settings.

### Samsung Notes

The file to use is a ZIP file that you need to create yourself, from the notes you exported as text using multi-selection in the notes list. The proprietary format that can be exported from the settings cannot be read, so this is the only solution.

## Setup

1. Install [Python](https://www.python.org/downloads/)
2. Clone or download this repository
3. Open a terminal in the [docs/external_imports](/docs/external_imports) directory
4. Install the dependencies: `py -m pip install -r requirements.txt`

## Run

Run `py path/to/converter.py -a app_name -i /path/to/backup_file.zip -o /path/to/export_file.json` to convert the backup file.

Run `py path/to/converter.py -h` to see how to use the arguments.

Ignore the [inputs](/docs/external_imports/inputs) and [outputs](/docs/external_imports/outputs) folder, they are only used for testing.
