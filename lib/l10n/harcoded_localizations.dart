import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/locale_manager.dart';

// All strings here are hardcoded because they are needed when no context is available, while AppLocalizations needs one

/// App name.
const _appName = 'Material Notes';

/// All supported localizations.
enum SupportedLocalizations {
  english(Locale('en')),
  french(Locale('fr')),
  turkish(Locale('tr')),
  ;

  final Locale locale;

  const SupportedLocalizations(this.locale);
}

/// Title for the quick action to add a note.
String get actionAddNoteTitle {
  const englishDefault = 'Add a note';

  final locale = LocaleManager().locale;

  final String title;

  if (locale == SupportedLocalizations.english.locale) {
    title = englishDefault;
  } else if (locale == SupportedLocalizations.french.locale) {
    title = 'Ajouter une note';
  } else if (locale == SupportedLocalizations.turkish.locale) {
    title = 'Not ekle';
  } else {
    log('Missing add note quick action string for locale: $locale');
    title = englishDefault;
  }

  return title;
}

/// Title and content of the welcome note.
Note get welcomeNote {
  const englishDefaultTitle = 'Welcome to $_appName!';
  const englishDefaultContent = 'Simple, local, material design notes';

  final locale = LocaleManager().locale;

  final String title;
  final String content;

  if (locale == SupportedLocalizations.english.locale) {
    title = englishDefaultTitle;
    content = englishDefaultContent;
  } else if (locale == SupportedLocalizations.french.locale) {
    title = 'Bienvenue dans $_appName !';
    content = 'Notes simples, locales, en material design';
  } else if (locale == SupportedLocalizations.turkish.locale) {
    title = '';
    content = 'Basit, çevrimdışı, materyal tasarımlı notlar';
  } else {
    log('Missing welcome note strings for locale: $locale');
    title = englishDefaultTitle;
    content = englishDefaultContent;
  }

  return Note(
    id: uuid.v4(),
    deleted: false,
    pinned: true,
    createdTime: DateTime.now(),
    editedTime: DateTime.now(),
    title: title,
    content: '[{"insert":"$content\\n\\n"}]',
  );
}
