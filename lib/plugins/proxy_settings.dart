import 'package:flutter/services.dart';
import 'package:Okuna/main.dart';

class ProxySettings {
  static const channel = const MethodChannel('social.okuna/proxy_settings');

  static Future<String> findProxy(Uri url) async {
    // mobile platforms seem to use the system proxy automatically, so return
    // `null` to use defaults
    if (isOnDesktop) {
      return await channel.invokeMethod('findProxy', {'url': url.toString()});
    } else {
      return Future.value(null);
    }
  }
}
