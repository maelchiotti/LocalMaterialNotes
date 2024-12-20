#!/usr/bin/env sh

mimir_version="$(awk '/flutter_mimir: /{gsub(/\^/, "", $2); print $2}' pubspec.yaml)"
checked_out_version="$(git -C .mimir describe --tags)"

if [ "$mimir_version" = "$checked_out_version" ]; then
  echo "mimir is up-to-date."
  exit 0
fi
echo "Updating from version $checked_out_version to $mimir_version."

git -C .mimir checkout "$mimir_version"
cargo generate-lockfile --manifest-path .mimir/Cargo.toml
mv .mimir/Cargo.lock .mimir-cargo.lock