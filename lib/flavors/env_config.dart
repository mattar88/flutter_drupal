import 'dart:developer';

import 'package:logger/logger.dart';

import '../app/values/app_values.dart';

class EnvConfig {
  final String appName;
  final String baseUrl;
  final String? apiPathPrefix;
  final String? clientId;
  final String? clientSecret;
  String? callbackPath;
  final bool shouldCollectCrashLog;

  /// if false hide the form login
  final bool loginWithPassword;

  ///if false hide the fields password and confirm password from signup form
  ///for security reason and the password generated after verification mail
  final bool signupWithPassword;
  late final Logger logger;

  EnvConfig(
      {required this.appName,
      required this.baseUrl,
      required this.clientId,
      required this.clientSecret,
      this.callbackPath,
      this.apiPathPrefix = "jsonapi",
      this.shouldCollectCrashLog = false,
      this.loginWithPassword = true,
      this.signupWithPassword = true})
      : assert(!baseUrl.endsWith('/'),
            'The baseUrl should not have "/" at the end') {
    callbackPath ??= '$baseUrl/';

    logger = Logger(
      printer: PrettyPrinter(
          methodCount: AppValues.loggerMethodCount,
          // number of method calls to be displayed
          errorMethodCount: AppValues.loggerErrorMethodCount,
          // number of method calls if stacktrace is provided
          lineLength: AppValues.loggerLineLength,
          // width of the output
          colors: true,
          // Colorful log messages
          printEmojis: true,
          // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
          ),
    );
  }
}
