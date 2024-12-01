from zipfile import ZipFile
import json
from datetime import datetime
import re

date_time_regex = "%y%m%d_%H%M%S"


def convert(input_file, output_file):
    notes = []

    try:
        with ZipFile(input_file, "r") as zip_file:
            for filename in zip_file.namelist():
                if not filename.endswith(".txt"):
                    continue

                title_split = filename.split("_")
                if not len(filename) > 0:
                    print(f"Failed to parse the title of {filename}")
                    continue

                date_time_match = re.search(r"\d{6}_\d{6}", filename)
                if not date_time_match:
                    print(f"Failed to parse the date and time of {filename}")
                    continue
                date_time = datetime.strptime(date_time_match[0], date_time_regex)

                title = title_split[0]
                content = zip_file.read(filename).decode()
                created_time = date_time
                edited_time = date_time
                pinned = False
                deleted = False

                if not content.endswith("\n"):
                    content += "\n"

                note = {
                    "title": title,
                    "content": json.dumps(
                        [{"insert": content}],
                        ensure_ascii=False,
                    ),
                    "created_time": created_time.isoformat(),
                    "edited_time": edited_time.isoformat(),
                    "pinned": pinned,
                    "deleted": deleted,
                }

                notes.append(note)
    except Exception as e:
        print(f"Error while reading the input file: {e}")
        exit(-1)

    notes_json = json.dumps(
        {
            "version": "",
            "encrypted": False,
            "notes": notes,
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
