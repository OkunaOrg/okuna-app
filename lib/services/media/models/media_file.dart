import 'dart:io';

import 'package:file_picker/file_picker.dart';

class MediaFile {
  final File file;
  final FileType type;

  const MediaFile(this.file, this.type);
}
