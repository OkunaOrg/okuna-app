import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

/// Temporal until https://github.com/dart-lang/mime/issues/13 hits
import 'package:mime/src/default_extension_map.dart';

import 'localization.dart';

class UtilsService {
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

  Future<String> getFileMimeType(File file) async {
    String mimeType = lookupMimeType(file.path);

    if (mimeType == null) {
      mimeType = await _getFileMimeTypeFromMagicHeaders(file);
    }

    return mimeType;
  }
  // LocalizationService localizationService
  String timeAgo(DateTime date) {
    /// Originally from https://gist.github.com/DineshKachhot/bc8cee616f30c323c1dd1e63a4bf65df
    final now = DateTime.now();
    final difference = now.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()}y';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return '1y';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()}w';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return '1w';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays}d';
    } else if (difference.inDays >= 1) {
      return '1d';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours}h';
    } else if (difference.inHours >= 1) {
      return '1h';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes}m';
    } else if (difference.inMinutes >= 1) {
      return '1m';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds}s';
    } else {
      return 'now';
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
