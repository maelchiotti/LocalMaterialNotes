# Code generation
.PHONY: gen gen_l10n gen_build gen_watch

gen: gen_l10n gen_build

gen_l10n:
	flutter gen-l10n

gen_build:
	dart run build_runner build --delete-conflicting-outputs

gen_watch:
	dart run build_runner watch --delete-conflicting-outputs


# Assets generation
.PHONY: gen_icon gen_splash gen_desc

gen_icon:
	dart run flutter_launcher_icons

gen_splash:
	dart run flutter_native_splash:create

gen_desc:
	py scripts/generate_full_description.py


# Build
.PHONY: release release_abi

release:
	flutter build apk --release

release_abi:
	flutter build apk --release --split-per-abi


# Update
.PHONY: update_flutter update_fastlane

update_flutter:
	flutter upgrade --force

update_fastlane:
	bundle update fastlane


# Miscellaneous
.PHONY: format clean

format:
	dart format .

clean:
	flutter clean