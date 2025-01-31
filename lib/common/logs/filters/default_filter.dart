import 'package:logger/logger.dart';

/// Default log filter.
class DefaultFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return event.level.value >= level!.value;
  }
}
