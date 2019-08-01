import 'dart:async';

import 'package:flutter/services.dart';

class ImageConverter {
  static const MethodChannel _channel =
      const MethodChannel('openspace.social/image_converter');

  static Future<List<int>> convertImage(List<int> imageData, [TargetFormat format = TargetFormat.JPEG]) async {
    String formatName;
    switch (format) {
      case TargetFormat.JPEG:
        formatName = 'JPEG';
        break;
      case TargetFormat.PNG:
        formatName = 'PNG';
        break;
    }
    final List<int> convertedData = await _channel.invokeMethod('convertImage', { 'imageData': imageData, 'format': formatName });
    return convertedData;
  }
}

enum TargetFormat {
  JPEG,
  PNG
}