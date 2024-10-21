import minify_html
import os
import yaml

root = os.getcwd()
path = os.path.join(root, "fastlane/metadata/android")

for language in os.listdir(path):
    if not os.path.isdir(os.path.join(path, language)):
        continue

    yaml_filepath = os.path.join(path, language, "full_description.yaml")

    # If the full description is not translated for that language, use the english one
    if not os.path.isfile(yaml_filepath):
        yaml_filepath = os.path.join(path, "en-US", "full_description.yaml")

    with open(yaml_filepath, mode="r", encoding="utf-8") as yaml_stream:
        try:
            # Read and minimize the description inside the YAML file
            yaml_file = yaml.safe_load(yaml_stream)
            full_description = yaml_file["full_description"]
            full_description_minified = minify_html.minify(
                full_description, keep_closing_tags=True
            )

            # Write the description into the text file
            text_filepath = os.path.join(path, language, "full_description.txt")
            with open(text_filepath, mode="w", encoding="utf-8") as text_file:
                text_file.write(full_description_minified)

            print("Generated full_description.txt for language " + language)
        except yaml.YAMLError as exception:
            print(exception)
