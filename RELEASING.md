# Releasing

## Checklist

### Upgrades, versioning and code generation

- [ ] Upgrade Flutter and Dart versions
- [ ] Bump application version
- [ ] Bump dependencies versions
- [ ] Re-generate generated files

### Changelogs

- [ ] Update [CHANGELOG.md](CHANGELOG.md)
- [ ] Update fastlane changelogs

### Descriptions

- [ ] Update the [README.md](README.md) description
- [ ] Update fastlane descriptions

### Localizations

- [ ] Update the localizations from [Crowdin](https://crowdin.com/project/localmaterialnotes)
- [ ] Update the [README.md](README.md) supported languages
- [ ] Update the [localizations completion](lib/l10n/localization_completion.dart)
- [ ] Update the [list of hardcoded localizations](lib/utils/hardcoded_localizations_utils.dart)

### Screenshots

- [ ] Update [`screenshotNotes`](lib/common/constants/notes.dart)
- [ ] Update fastlane screenshots
