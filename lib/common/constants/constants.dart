import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/enums/mime_type.dart';
import 'package:localmaterialnotes/common/logs/app_logger.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:parchment/codecs.dart';
import 'package:saf_stream/saf_stream.dart';
import 'package:saf_util/saf_util.dart';

/// Contact email address.
const contactEmail = 'contact@maelchiotti.dev';

/// Key of the application's root navigator.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root navigator key');

/// Application's localizations.
final l = AppLocalizations.of(rootNavigatorKey.currentContext!);

/// Flutter's localizations.
final flutterL = Localizations.of<MaterialLocalizations>(rootNavigatorKey.currentContext!, MaterialLocalizations);

/// Console and file logger.
final logger = AppLogger();

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

/// The value to apply to the alpha channel to get a subdued color.
const subduedAlpha = 150;
