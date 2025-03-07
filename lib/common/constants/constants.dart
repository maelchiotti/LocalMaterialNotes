import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parchment/codecs.dart';
import 'package:saf_stream/saf_stream.dart';
import 'package:saf_util/saf_util.dart';
import 'package:uuid/uuid.dart';

import '../../l10n/app_localizations/app_localizations.g.dart';
import '../logs/app_logger.dart';

/// An UUID generator.
final uuid = Uuid();

/// Contact email address.
const contactEmail = 'contact@maelchiotti.dev';

/// Global [WidgetRef] used to access the providers even after a page has been removed from the widget tree.
late WidgetRef globalRef;

/// Key of the application's root navigator.
final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'Root navigator key');

/// Application's localizations.
final l = AppLocalizations.of(rootNavigatorKey.currentContext!);

/// Flutter's localizations.
final fl = Localizations.of<MaterialLocalizations>(rootNavigatorKey.currentContext!, MaterialLocalizations);

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

/// The value to apply to the alpha channel to get a subdued color.
const subduedAlpha = 150;

/// Frequency of the automatic bin emptying.
const automaticEmptyBinValues = [1.0, 3.0, 7.0, 14.0, 30.0, -1.0];

/// Frequencies of the automatic export feature.
const automaticExportFrequenciesValues = [1.0, 3.0, 7.0, 14.0, 30.0];

/// Delays for the lock feature.
const lockDelayValues = [0.0, 3.0, 5.0, 10.0, 30.0, 60.0, 120.0, 300.0, -1.0];

/// The last time the application was in the foreground.
var lastForegroundTimestamp = DateTime.timestamp();
