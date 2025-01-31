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


# Tests
.PHONY: test_all

test_all:
	patrol test -t integration_test --dart-define=INTEGRATION_TEST=true


# Build
.PHONY: release

release:
	flutter build apk --release


# Update
.PHONY: update_flutter update_fastlane

update_flutter:
	flutter upgrade --force

update_fastlane:
	bundle update fastlane


# Miscellaneous
.PHONY: clean

clean:
	flutter clean