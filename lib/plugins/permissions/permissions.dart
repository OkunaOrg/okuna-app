import 'dart:async';

import 'package:flutter/services.dart';

class Permissions {
  static const MethodChannel _channel = const MethodChannel('openbook.social/permissions');
  static Future<bool> checkPermission(Permission permission) {
    return _channel.invokeMethod('checkPermission', { 'permission': getPermissionString(permission) });
  }
  static Future<bool> requestPermission(Permission permission) {
    return _channel.invokeMethod('requestPermission', { 'permission': getPermissionString(permission) });
  }
  static Future<bool> checkOrRequestPermission(Permission permission) async {
    if (await Permissions.checkPermission(permission)) {
      return true;
    } else {
      return await Permissions.requestPermission(permission);
    }
  }
}

enum Permission {
  WriteExternalStorage,
}

String getPermissionString(Permission permission) {
  switch (permission) {
    case Permission.WriteExternalStorage:
      return "WRITE_EXTERNAL_STORAGE";
    default:
      return "ERROR";
  }
}