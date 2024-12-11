import argparse
import json
import os

apps = ["samsung_notes", "d_notes"]


def main():
    args = parse_args()

    app = args.app
    input_file = args.input_file
    output_file = args.output_file

    notes = []
    labels = []

    # Samsung Notes
    if app == apps[0]:
        from apps.samsung_notes import convert

        notes, labels = convert(input_file)

    # DNotes
    elif app == apps[1]:
        from apps.dnotes import convert

        notes, labels = convert(input_file)

    write(output_file, notes, labels)


def write(output_file, notes, labels):
    notes_json = json.dumps(
        {
            "notes": notes,
            "labels": labels,
        },
        ensure_ascii=False,
        indent=4,
    )

    try:
        with open(output_file, "w", encoding="utf-8") as json_file:
            json_file.write(notes_json)
    except Exception as e:
        print(f"Error while writing to output file: {e}")
        exit(-1)


def parse_args():
    parser = argparse.ArgumentParser(
        prog="Material Notes external exports converter",
        description="Converts exports from other note-taking apps to the format used by Material Notes.",
    )
    parser.add_argument(
        "-a",
        "--app",
        help=f"name of the application (allowed values: {apps})",
        required=True,
        choices=apps,
    )
    parser.add_argument(
        "-i",
        "--input_file",
        help="absolute path to the export file from the external application (DNotes: exported ZIP file; Samsung Notes: ZIP file containing all the notes exported as text files through multi-selection)",
        required=True,
    )
    parser.add_argument(
        "-o",
        "--output_file",
        help="absolute path to the file where to write the output in the Material Notes format",
        required=True,
    )

    args = parser.parse_args()

    if not os.path.isfile(args.input_file):
        print("The input file does not exist.")
        exit(-1)

    return args


if __name__ == "__main__":
    main()
