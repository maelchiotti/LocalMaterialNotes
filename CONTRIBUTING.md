# Contributing

## Localization

> If you are not familiar with Flutter or even coding, you can just translate the strings from the files listed below and provide them to me in a new [issue](https://github.com/maelchiotti/LocalMaterialNotes/issues), I will do the rest.

In order to improve or add support for a language, please follow these steps:

1. [Fork](https://github.com/maelchiotti/LocalMaterialNotes/fork) this repository, and uncheck the "Copy the `main` branch only" option. Then, create a new branch from the `dev` branch.
1. Localize the strings found in two different places:
    - The `app_XX.arb` file located in [`lib/l10n`](lib/l10n) (where `XX` corresponds to the language code), that contains the vast majority of all strings. Please make sure that you do not localize any parameter name (ex: `{parameter}`) and that you do escape single quotes (ex: `I''m ok` instead of `I'm ok`).
    - The [`hardcoded_localizations.dart`](lib/l10n/hardcoded_localizations.dart), that contains a few specific strings that need to be hardcoded.
2. Generate localized strings with the `flutter gen-l10n` command. Check that the `lib/l10n/untranslated.txt` file is empty for your language, otherwise it will indicate which strings you did not translate.
3. Add or update your language in the [Supported languages](README.md#supported-languages) section of the README (the table should be sorted alphabetically on the language name).
4. If it's your first time contributing to localizations, add yourself to the [Localization credits](README.md#localization) section of the README.
5. Make a pull request targeting the [dev](https://github.com/maelchiotti/LocalMaterialNotes/tree/dev) branch.
