import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Log filter that only logs messages in release mode.
class ReleaseFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (!kReleaseMode) {
      return false;
    }

    return event.level.value >= level!.value;
  }
}
