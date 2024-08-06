# Generates all full_description.txt files

import minify_html
import os
import yaml

root = os.getcwd()
for language in os.listdir(root):
    if not os.path.isdir(os.path.join(root, language)):
        continue

    yaml_filepath = os.path.join(root, language, "full_description.yaml")

    if not os.path.isfile(yaml_filepath):
        continue

    with open(yaml_filepath, mode="r", encoding="utf-8") as yaml_stream:
        try:
            # Read and minimize the description inside the YAML file
            yaml_file = yaml.safe_load(yaml_stream)
            full_description = yaml_file["full_description"]
            full_description_minified = minify_html.minify(
                full_description, keep_closing_tags=True
            )

            # Write the description into the text file
            text_filepath = os.path.join(root, language, "full_description.txt")
            with open(text_filepath, mode="w", encoding="utf-8") as text_file:
                text_file.write(full_description_minified)

            print("Generated full_description.txt for language " + language)
        except yaml.YAMLError as exception:
            print(exception)
