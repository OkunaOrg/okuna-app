import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:Openbook/services/validation.dart';
export 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static const Map IMAGE_RATIOS = {
    OBImageType.avatar: {'x': 1.0, 'y': 1.0},
    OBImageType.cover: {'x': 16.0, 'y': 9.0}
  };

  ValidationService _validationService;

  void setValidationService(ValidationService validationService) {
    _validationService = validationService;
  }

  Future<File> pickImage(
      {@required OBImageType imageType,
      ImageSource source = ImageSource.gallery}) async {
    var image = await ImagePicker.pickImage(source: source);

    if (image == null) {
      return null;
    }

    if (!await _validationService.isImageAllowedSize(image, imageType)) {
      throw ImageTooLargeException(_validationService.getAllowedImageSize(imageType));
    }

    double ratioX =
        imageType != OBImageType.post ? IMAGE_RATIOS[imageType]['x'] : null;
    double ratioY =
        imageType != OBImageType.post ? IMAGE_RATIOS[imageType]['y'] : null;

    File croppedFile = await ImageCropper.cropImage(
      toolbarTitle: 'Edit image',
      toolbarColor: Colors.black,
      statusBarColor: Colors.black,
      toolbarWidgetColor: Colors.white,
      sourcePath: image.path,
      ratioX: ratioX,
      ratioY: ratioY,
    );

    return croppedFile;
  }

  Future<File> pickVideo({ImageSource source = ImageSource.gallery}) async {
    var video = await ImagePicker.pickVideo(source: source);

    return video;
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
