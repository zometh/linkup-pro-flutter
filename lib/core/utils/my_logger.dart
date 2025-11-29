
import 'package:logger/logger.dart';

enum LogType { trace, debug, info, warning, error, fatal }
class MyLogger {
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      dateTimeFormat: (d) => d.toIso8601String(),
    ),
  );
  void log(String message, {LogType type = LogType.debug, dynamic error, StackTrace? stackTrace}) {
    switch (type) {
      case LogType.trace:
        logger.t(message);
        break;
      case LogType.debug:
        logger.d(message);
        break;
      case LogType.info:
        logger.i(message);
        break;
      case LogType.warning:
        logger.w(message);
        break;
      case LogType.error:
        logger.e(message, error: error, stackTrace: stackTrace);
        break;
      case LogType.fatal:
        logger.f(message, error: error, stackTrace: stackTrace);
        break;
    }
  }

}