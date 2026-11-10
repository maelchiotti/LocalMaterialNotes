#!/bin/bash
# Prepares a Claude Code cloud session: Flutter SDK, dependencies and generated code.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}"

# Flutter SDK, at the version pinned in .fvmrc
version=$(sed -n 's/.*"flutter": *"\([^"]*\)".*/\1/p' .fvmrc)
sdk="$HOME/flutter-$version"
if [ ! -x "$sdk/bin/flutter" ]; then
  rm -rf "$sdk.tmp"
  mkdir -p "$sdk.tmp"
  curl -fsSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$version-stable.tar.xz" \
    | tar -xJ -C "$sdk.tmp"
  mv "$sdk.tmp/flutter" "$sdk"
  rm -rf "$sdk.tmp"
fi
export PATH="$sdk/bin:$PATH"
git config --global --get-all safe.directory | grep -qx "$sdk" || git config --global --add safe.directory "$sdk"
if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$sdk/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi
flutter --version >/dev/null 2>&1

# Dependencies, when the pubspec changed
mkdir -p .dart_tool
hashes=.dart_tool/.session-start-pub.sha256
if ! sha256sum --check --status "$hashes" 2>/dev/null; then
  rm -f "$hashes"
  flutter pub get >/dev/null
  sha256sum .claude/hooks/session-start.sh .fvmrc pubspec.yaml pubspec.lock > "$hashes"
fi

# Generated code (*.g.dart and localizations are not committed), when the sources changed
hashes=.dart_tool/.session-start-codegen.sha256
sources() { find lib -name '*.dart' ! -name '*.g.dart' -o -name '*.arb'; echo build.yaml l10n.yaml pubspec.lock; }
if ! sha256sum --check --status "$hashes" 2>/dev/null; then
  rm -f "$hashes"
  dart run build_runner build >/dev/null
  flutter gen-l10n >/dev/null
  sources | sort | xargs sha256sum > "$hashes"
fi
