import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ReleaseFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (!kReleaseMode) {
      return false;
    }

    return event.level.value >= level!.value;
  }
}
