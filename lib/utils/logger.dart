import 'package:logger/logger.dart';

Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 10,
  ),
);

Logger loggerNoStack = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
  ),
);