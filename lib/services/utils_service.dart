import 'dart:io';

import 'package:dcache/dcache.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

/// Temporal until https://github.com/dart-lang/mime/issues/13 hits
import 'package:mime/src/default_extension_map.dart';
import 'package:pigment/pigment.dart';

import 'localization.dart';

class UtilsService {
  static SimpleCache<String, bool> hexColorIsDarkCache =
      SimpleCache(storage: SimpleStorage(size: 30));

  static SimpleCache<String, Color> parseHexColorCache =
      SimpleCache(storage: SimpleStorage(size: 30));

  Future<bool> fileHasImageMimeType(File file) async {
    String fileMimeType =
        await getFileMimeType(file) ?? 'application/octet-stream';
    MediaType fileMediaType = MediaType.parse(fileMimeType);

    return fileMediaType.type == 'image';
  }

  Future<String> getFileExtensionForFile(File file) async {
    String fileMimeType =
        await getFileMimeType(file) ?? 'application/octet-stream';

    return getFileExtensionForMimeType(fileMimeType);
  }

  String getFileExtensionForMimeType(String mimeType) {
    return lookupExtension(mimeType);
  }

  String geFileNameMimeType(String fileName) {
    return lookupMimeType(fileName);
  }

  Future<String> getFileMimeType(File file) async {
    String mimeType = lookupMimeType(file.path);

    if (mimeType == null) {
      mimeType = await _getFileMimeTypeFromMagicHeaders(file);
    }

    return mimeType ?? 'application/octet-stream';
  }

  bool hexColorIsDark(String hexColor) {
    return hexColorIsDarkCache.get(hexColor) ??
        _checkAndStoreHexColorIsDark(hexColor);
  }

  bool _checkAndStoreHexColorIsDark(String hexColor) {
    Color color = parseHexColor(hexColor);
    bool isDark = colorIsDark(color);
    hexColorIsDarkCache.set(hexColor, isDark);
    return isDark;
  }

  bool colorIsDark(Color color) {
    print(color.computeLuminance());
    return color.computeLuminance() < 0.179;
  }

  Color parseHexColor(String hexColor) {
    return parseHexColorCache.get(hexColor) ?? _parseAndStoreColor(hexColor);
  }

  Color _parseAndStoreColor(String colorValue) {
    Color color = Pigment.fromString(colorValue);
    parseHexColorCache.set(colorValue, color);
    return color;
  }

  // LocalizationService localizationService
  String timeAgo(DateTime date, LocalizationService _localizationService) {
    /// Originally from https://gist.github.com/DineshKachhot/bc8cee616f30c323c1dd1e63a4bf65df
    final now = DateTime.now();
    final difference = now.difference(date);
    String years = _localizationService.post__time_short_years;
    String weeks = _localizationService.post__time_short_weeks;
    String days = _localizationService.post__time_short_days;
    String hours = _localizationService.post__time_short_hours;
    String mins = _localizationService.post__time_short_minutes;
    String seconds = _localizationService.post__time_short_seconds;

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()}$years';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return _localizationService.post__time_short_one_year;
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()}$weeks';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return _localizationService.post__time_short_one_week;
    } else if (difference.inDays >= 2) {
      return '${difference.inDays}$days';
    } else if (difference.inDays >= 1) {
      return _localizationService.post__time_short_one_day;
    } else if (difference.inHours >= 2) {
      return '${difference.inHours}$hours';
    } else if (difference.inHours >= 1) {
      return _localizationService.post__time_short_one_hour;
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes}$mins';
    } else if (difference.inMinutes >= 1) {
      return _localizationService.post__time_short_one_minute;
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds}$seconds';
    } else {
      return _localizationService.post__time_short_now_text;
    }
  }

  Future<String> _getFileMimeTypeFromMagicHeaders(File file) async {
    // TODO When file uploads become larger, this needs to be turned into a stream
    List<int> fileBytes = file.readAsBytesSync();

    int magicHeaderBytesLeft = 12;
    List<int> magicHeaders = [];

    for (final fileByte in fileBytes) {
      if (magicHeaderBytesLeft == 0) break;
      magicHeaders.add(fileByte);
      magicHeaderBytesLeft--;
    }

    String mimetype = lookupMimeType(file.path, headerBytes: magicHeaders);

    return mimetype;
  }

  /// Add an override for common extensions since different extensions may map
  /// to the same MIME type.
  final Map<String, String> _preferredExtensionsMap = <String, String>{
    'application/vnd.ms-excel': 'xls',
    'image/jpeg': 'jpg',
    'text/x-c': 'c'
  };

  /// Lookup file extension by a given MIME type.
  /// If no extension is found, `null` is returned.
  String lookupExtension(String mimeType) {
    if (_preferredExtensionsMap.containsKey(mimeType)) {
      return _preferredExtensionsMap[mimeType];
    }
    String extension;
    defaultExtensionMap.forEach((String ext, String test) {
      if (mimeType.toLowerCase() == test) {
        extension = ext;
      }
    });
    return extension;
  }
}
