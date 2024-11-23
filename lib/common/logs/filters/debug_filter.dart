import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Log filter that only logs messages in debug mode.
class DebugFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (!kDebugMode) {
      return false;
    }

    return event.level.value >= level!.value;
  }
}
