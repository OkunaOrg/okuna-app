import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:Okuna/services/validation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../provider.dart';
import 'modal_service.dart';
export 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static Uuid uuid = new Uuid();

  static const Map IMAGE_RATIOS = {
    OBImageType.avatar: {'x': 1.0, 'y': 1.0},
    OBImageType.cover: {'x': 16.0, 'y': 9.0}
  };

  ValidationService _validationService;

  void setValidationService(ValidationService validationService) {
    _validationService = validationService;
  }

  Future<File> pickImage(
      {@required OBImageType imageType, @required BuildContext context}) async {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    ModalService modalService = openbookProvider.modalService;
    modalService.openMediaPicker(context: context);
  }

  Future<File> pickVideo({ImageSource source = ImageSource.gallery}) async {
    var video = await ImagePicker.pickVideo(source: source);

    return video;
  }

  Future<File> processImage(File image) async {
    /// Fix rotation issue on android
    if (Platform.isAndroid)
      return await FlutterExifRotation.rotateImage(path: image.path);
    return image;
  }

  Future<String> _getTempPath() async {
    final directory = await getTemporaryDirectory();

    return directory.path;
  }
}

class ImageTooLargeException implements Exception {
  final int limit;

  const ImageTooLargeException(this.limit);

  String toString() =>
      'ImageToLargeException: Images can\'t be larger than $limit';

  int getLimitInMB() {
    return limit ~/ 1048576;
  }
}

enum OBImageType { avatar, cover, post }
