#!/usr/bin/env sh

mimir_version="$(yq -r '.dependencies.flutter_mimir' pubspec.yaml | cut -d '^' -f 2)"
checked_out_version="$(git -C .mimir describe --tags)"

if [ "$mimir_version" = "$checked_out_version" ]; then
  echo "mimir is up-to-date."
  exit 0
fi

echo "updating from version $checked_out_version to $mimir_version."

git -C .mimir checkout flutter_mimir-v"$mimir_version"
cargo generate-lockfile --manifest-path .mimir/Cargo.toml
mv .mimir/Cargo.lock .mimir-cargo.lock