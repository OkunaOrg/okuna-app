import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:Okuna/plugins/image_converter/image_converter.dart';
import 'package:Okuna/services/validation.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
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
      {@required OBImageType imageType}) async {
    List<Asset> pickedAssets =
        await MultiImagePicker.pickImages(maxImages: 1, enableCamera: true);

    if (pickedAssets.isEmpty) {
      return null;
    }

    Asset pickedAsset = pickedAssets.first;

    String tmpImageName = uuid.v4() + '.jpg';
    final path = await _getTempPath();
    final file = File('$path/$tmpImageName');
    ByteData byteData = await pickedAsset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    imageData = await ImageConverter.convertImage(imageData);
    file.writeAsBytesSync(imageData);

    if (!await _validationService.isImageAllowedSize(file, imageType)) {
      throw ImageTooLargeException(
          _validationService.getAllowedImageSize(imageType));
    }

    File processedImage = await processImage(file);

    double ratioX =
        imageType != OBImageType.post ? IMAGE_RATIOS[imageType]['x'] : null;
    double ratioY =
        imageType != OBImageType.post ? IMAGE_RATIOS[imageType]['y'] : null;

    File croppedFile = await ImageCropper.cropImage(
      toolbarTitle: 'Edit image',
      toolbarColor: Colors.black,
      statusBarColor: Colors.black,
      toolbarWidgetColor: Colors.white,
      sourcePath: processedImage.path,
      ratioX: ratioX,
      ratioY: ratioY,
    );

    return croppedFile;
  }

  Future<File> pickVideo({ImageSource source = ImageSource.gallery}) async {
    var video = await ImagePicker.pickVideo(source: source);

    return video;
  }

  Future<File> processImage(File image) async {
    /// Fix rotation issue on android
    if (Platform.isAndroid)
      return FlutterExifRotation.rotateImage(path: image.path);
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
