# Generates all full_description.txt files

import minify_html
import os
import yaml

root = os.path.join("fastlane", "metadata", "android")
for item in os.listdir(root):
    if os.path.isdir(os.path.join(root, item)):
        yaml_filepath = os.path.join(root, item, "full_description.yaml")
        with open(yaml_filepath) as yaml_stream:
            try:
                # Read and minimize the description inside the YAML file
                yaml_file = yaml.safe_load(yaml_stream)
                full_description = yaml_file["full_description"]
                full_description_minified = minify_html.minify(
                    full_description, keep_closing_tags=True
                )

                # Write the description into the text file
                text_filepath = os.path.join(root, item, "full_description.txt")
                with open(text_filepath, mode="w") as text_file:
                    text_file.write(full_description_minified)
            except yaml.YAMLError as exception:
                print(exception)
