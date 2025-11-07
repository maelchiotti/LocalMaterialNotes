#!/usr/bin/env sh

# Extract the dependency version
mimir_version="$(yq -r '.dependencies.flutter_mimir' pubspec.yaml | cut -d '^' -f 2)"

# Find the closest matching tag on GitHub that starts with that version
full_tag="$(git -C .mimir tag --list "flutter_mimir-v${mimir_version}*" | sort -V | tail -n 1)"

if [ -z "$full_tag" ]; then
  echo "Error: no matching tag found for version $mimir_version"
  exit 1
fi

checked_out_version="$(git -C .mimir describe --tags)"

if [ "$full_tag" = "$checked_out_version" ]; then
  echo "mimir is up-to-date ($checked_out_version)."
  exit 0
fi

echo "updating from version $checked_out_version to $full_tag."

git -C .mimir checkout "$full_tag"
cargo generate-lockfile --manifest-path .mimir/Cargo.toml
mv .mimir/Cargo.lock .mimir-cargo.lock