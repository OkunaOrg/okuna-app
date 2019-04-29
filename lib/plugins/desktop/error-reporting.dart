import 'package:flutter/services.dart';

class DesktopErrorReporting {
  static const channel = const MethodChannel('social.openbook.desktop/error-reporting');

  static Future reportError(dynamic error, dynamic stackTrace) async {
    await channel.invokeMethod('reportError', {
      'error': error.toString(),
      'stackTrace': stackTrace.toString(),
    });
  }
}
