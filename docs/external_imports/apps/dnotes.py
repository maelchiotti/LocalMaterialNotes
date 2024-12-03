from zipfile import ZipFile
import json
from dateutil.parser import parse


def convert(input_file, output_file):
    labels = []
    notes = []

    try:
        with ZipFile(input_file, "r") as zip_file:
            backup = zip_file.read("temp_backup/manual_backup.txt")
            backup_json = json.loads(backup)

            # Labels
            backup_categories = backup_json["categories"]
            for backup_category in backup_categories:
                name = backup_category["title"]
                color_hex = backup_category["color"]
                visible = not backup_category["isHidden"]
                pinned = False

                label = {
                    "name": name,
                    "color_hex": color_hex,
                    "visible": visible,
                    "pinned": pinned,
                }

                labels.append(label)

            # Notes
            backup_notes = backup_json["notes"]
            for backup_note in backup_notes:
                if backup_note["isChecklist"] == 1 or backup_note["alarm"] != 0:
                    continue

                title = backup_note["title"]
                created_time = parse(backup_note["createdDate"])
                edited_time = parse(backup_note["lastModifiedDate"])
                pinned = bool(backup_note["isPinned"])
                deleted = bool(backup_note["isTrash"])

                content = backup_note["content"]
                if not content.endswith("\n"):
                    content += "\n"

                note_labels = []
                category_id = backup_note["categoryId"]
                if len(category_id) > 0:
                    category = None
                    for backup_category in backup_categories:
                        if backup_category["uuid"] == category_id:
                            category = backup_category
                    note_labels.append(category["title"])

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
                    "labels": note_labels,
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
