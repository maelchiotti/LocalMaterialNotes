# Code generation
.PHONY: gen_l10n gen_build gen_watch gen_icon gen_splash gen_full_descriptions test_all

gen_l10n:
	flutter gen-l10n

gen_build:
	dart run build_runner build --delete-conflicting-outputs

gen_watch:
	dart run build_runner watch --delete-conflicting-outputs

gen_icon:
	dart run flutter_launcher_icons

gen_splash:
	dart run flutter_native_splash:create

gen_full_descriptions:
	py docs/scripts/generate_full_description.py

# Tests
.PHONY: test_all

test_all:
	patrol test -t integration_test --dart-define=INTEGRATION_TEST=true