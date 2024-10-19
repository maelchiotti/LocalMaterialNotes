import json
import os
import datetime
import re


def txt_to_json(input_folder, output_file):
    """Converts TXT files with date/time in filenames to a JSON file."""

    notes = []
    for filename in os.listdir(input_folder):
        if filename.endswith(".txt"):
            filepath = os.path.join(input_folder, filename)

            # Extract date and time from filename using regular expression
            match = re.match(r".*_(\d{6})_(\d{6})\.txt", filename)
            if match:
                try:
                    date_str = match.group(1)
                    time_str = match.group(2)
                    dt = datetime.datetime.strptime(date_str + time_str, "%y%m%d%H%M%S")
                    timestamp = dt.isoformat()
                except ValueError:
                    print(f"Invalid date/time format in filename: {filename}")
                    timestamp = datetime.datetime.now().isoformat()  # Fallback
            else:
                print(f"Could not extract date/time from filename: {filename}")
                timestamp = datetime.datetime.now().isoformat()  # Fallback

            try:
                with open(filepath, "r", encoding="utf-8") as f:
                    content = f.read()

                title = filename.split("_")[0]  # Extract title

                note = {
                    "deleted": False,
                    "pinned": False,
                    "created_time": timestamp,
                    "edited_time": timestamp,
                    "title": title,
                    "content": json.dumps([{"insert": content}]),
                }
                notes.append(note)

            except Exception as e:
                print(f"Error processing {filename}: {e}")

    # Create the JSON structure
    json_data = {"version": "", "encrypted": False, "notes": notes}

    # Write the JSON data to the output file
    try:
        with open(output_file, "w", encoding="utf-8") as outfile:
            json.dump(json_data, outfile, indent=4, ensure_ascii=False)
        print(f"JSON data written to {output_file}")

    except Exception as e:
        print(f"Error writing to {output_file}: {e}")


# Example usage:
input_folder = r"/path/to/your/txt/files/folder"  # Replace with your folder path
output_file = r"/path/to/output/output.json"  # Replace with desired output filename
txt_to_json(input_folder, output_file)
