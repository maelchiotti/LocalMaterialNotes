import 'dart:io';

import 'package:flutter/foundation.dart';

final bool kIsMobile = kIsWeb
    ? defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS
    : Platform.isAndroid || Platform.isIOS;

final bool kIsDesktop = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

final bool kIsAndroidApp = !kIsWeb && Platform.isAndroid;
