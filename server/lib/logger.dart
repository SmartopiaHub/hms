// Copyright (c) Smartopia AI (smartopia.ai). All rights reserved.
// Licensed under the GNU General Public License v3.0 (GPL-3.0).
// See https://www.gnu.org/licenses/gpl-3.0.html for details.

import 'dart:developer' as developer;
import 'dart:io';

import 'package:logging/logging.dart';

/// Logging utility functions for the application.
void logInfo(String message) {
  Logger.root.info(message);
}

/// Logs a warning message.
void logWarning(String message, [Object? error, StackTrace? stackTrace]) {
  Logger.root.warning(message, error, stackTrace);
}

/// Logs an error message.
void logError(String message, [Object? error, StackTrace? stackTrace]) {
  Logger.root.severe(message, error, stackTrace);
}

//final _logger = Logger('hms_server');

/// Initializes the logging system for the server application.
void initLogging() {
  // Set the root level and attach a console handler
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    final time = record.time.toIso8601String();
    
    final msg = '${record.level.name} [$time] ${record.message}';
    developer.log(msg, error: record.error, stackTrace: record.stackTrace);
    stdout.writeln(msg + 
        (record.error != null ? ' Error: ${record.error}' : '') +
        (record.stackTrace != null ? '\nStackTrace: ${record.stackTrace}' : ''));
    //print('${record.level.name} [$time] ${record.loggerName}: ${record.message}');
  });
}