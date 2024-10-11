import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/enums/mime_type.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:parchment/codecs.dart';
import 'package:saf_stream/saf_stream.dart';
import 'package:saf_util/saf_util.dart';

/// Contact email address.
const contactEmail = 'contact@maelchiotti.dev';

/// Key of the application's root navigator.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root navigator key');

/// Key of the application's shell.
final shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Shell navigator key');

/// Key of the application's drawer.
final scaffoldDrawerKey = GlobalKey<ScaffoldState>(debugLabel: 'Scaffold drawer key');

/// Application's localizations.
final localizations = AppLocalizations.of(rootNavigatorKey.currentContext!);

/// Codec to encode and decode Markdown files in fleather.
const parchmentMarkdownCodec = ParchmentMarkdownCodec();

/// Focus node of the note content text editor.
final editorFocusNode = FocusNode(debugLabel: 'Editor focus node');

/// Utilities for the Storage Access Framework (SAF) APIs.
final safUtil = SafUtil();

/// Read and write methods for files through the Storage Access Framework (SAF) APIs.
final safStream = SafStream();

/// Type group for the JSON file format.
final jsonTypeGroup = XTypeGroup(
  label: MimeType.json.label,
  extensions: [MimeType.json.extension],
  mimeTypes: [MimeType.json.value],
);

/// Type group for the ZIP file format.
final zipTypeGroup = XTypeGroup(
  label: MimeType.zip.label,
  extensions: [MimeType.zip.extension],
  mimeTypes: [MimeType.zip.value],
);
