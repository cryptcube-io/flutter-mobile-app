import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LoggerService {
  static const int MAX_FILE_SIZE = 1024 * 1024;
  static const int BACKUP_COUNT = 5;

  static Future<void> initializeLogger() async {
    final appDir = await getApplicationDocumentsDirectory();
    final logDir = Directory('${appDir.path}/logs');
    await logDir.create(recursive: true);
    
    Logger.root.level = Level.ALL;
    
    final consoleAppender = PrintAppender();
    final infoAppender = RotatingFileAppender(
      baseFilePath: '${logDir.path}/info.log',
      rotateAtSizeBytes: MAX_FILE_SIZE,
      keepRotateCount: BACKUP_COUNT,
    );
    final debugAppender = RotatingFileAppender(
      baseFilePath: '${logDir.path}/debug.log',
      rotateAtSizeBytes: MAX_FILE_SIZE,
      keepRotateCount: BACKUP_COUNT,
    );
    final errorAppender = RotatingFileAppender(
      baseFilePath: '${logDir.path}/error.log',
      rotateAtSizeBytes: MAX_FILE_SIZE,
      keepRotateCount: BACKUP_COUNT,
    );
    
    // Remove previous attachments to prevent duplication
    // Just use the listener approach for more control
    Logger.root.onRecord.listen((record) {
      // Always print to console
      consoleAppender.handle(record);
      
      // Direct to the appropriate file based on level
      if (record.level == Level.INFO) {
        infoAppender.handle(record);
      } else if (record.level == Level.FINE) {
        debugAppender.handle(record);
      } else if (record.level >= Level.SEVERE) {
        errorAppender.handle(record);
      }
      
      // Additional error logging
      if (record.error != null || record.stackTrace != null) {
        print('Error: ${record.error}');
        print('StackTrace: ${record.stackTrace}');
      }
    });
  }
  
  static final Logger logger = Logger('AppLogger');
  
  static void logInfo(String message) {
    logger.info(message);
  }
  
  static void logDebug(String message) {
    logger.fine(message);
  }
  
  static void logError(String message, [Object? error, StackTrace? stackTrace]) {
    logger.severe(message, error, stackTrace);
  }
}

mixin LoggerMixin on Object {
  Logger get logger => Logger('${runtimeType}Logger');
  
  void logInfo(String message) {
    logger.info(message);
  }
  
  void logDebug(String message) {
    logger.fine(message);
  }
  
  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    logger.severe(message, error, stackTrace);
  }
}