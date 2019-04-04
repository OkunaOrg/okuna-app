import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

/// Temporal until https://github.com/dart-lang/mime/issues/13 hits
import 'package:mime/src/default_extension_map.dart';

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
