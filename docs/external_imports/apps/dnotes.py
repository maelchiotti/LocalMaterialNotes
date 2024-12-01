from zipfile import ZipFile
import json
from dateutil.parser import parse


def convert(input_file, output_file):
    notes = []

    try:
        with ZipFile(input_file, "r") as zip_file:
            backup = zip_file.read("temp_backup/manual_backup.txt")
            backup_json = json.loads(backup)
            backup_notes = backup_json["notes"]

            for backup_note in backup_notes:
                if backup_note["isChecklist"] == 1 or backup_note["alarm"] != 0:
                    continue

                title = backup_note["title"]
                content = backup_note["content"]
                created_time = parse(backup_note["createdDate"])
                edited_time = parse(backup_note["lastModifiedDate"])
                pinned = bool(backup_note["isPinned"])
                deleted = bool(backup_note["isTrash"])

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
