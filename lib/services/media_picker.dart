import 'dart:io';
import 'package:Okuna/pages/home/modals/media_picker/media_picker.dart';
import 'package:Okuna/plugins/image_converter/image_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:Okuna/services/validation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';

import 'modal_service.dart';
export 'package:image_picker/image_picker.dart';

class MediaPickerService {
  static Uuid uuid = new Uuid();

  static const Map IMAGE_RATIOS = {
    OBImageType.avatar: {'x': 1.0, 'y': 1.0},
    OBImageType.cover: {'x': 16.0, 'y': 9.0}
  };

  ValidationService _validationService;
  ModalService _modalService;

  void setValidationService(ValidationService validationService) {
    _validationService = validationService;
  }

  void setModalService(ModalService modalService) {
    _modalService = modalService;
  }

  Future<File> pickMedia(
      {@required BuildContext context,
      OBMediaPickerMode mode = OBMediaPickerMode.all}) async {
    AssetEntity pickedMediaItem =
        await _modalService.openMediaPicker(context: context);
    if (pickedMediaItem == null) return null;
    return pickedMediaItem.file;
  }

  Future<File> pickImage(
      {@required OBImageType imageType, @required BuildContext context}) async {
    File pickedImage =
        await pickMedia(context: context, mode: OBMediaPickerMode.images);

    return pickedImage;

    if (pickedImage == null) return null;

    List<int> convertedImageData =
        await ImageConverter.convertImage(pickedImage.readAsBytesSync());

    String tmpImageName = uuid.v4() + '.jpg';
    final path = await _getTempPath();
    final file = File('$path/$tmpImageName');
    file.writeAsBytesSync(convertedImageData);

    if (!await _validationService.isImageAllowedSize(file, imageType)) {
      throw ImageTooLargeException(
          _validationService.getAllowedImageSize(imageType));
    }

    return file;

    File processedImage = await processImage(file);

    if (imageType == OBImageType.post) return processedImage;

    double ratioX = IMAGE_RATIOS[imageType]['x'];
    double ratioY = IMAGE_RATIOS[imageType]['y'];

    File croppedFile = await ImageCropper.cropImage(
      toolbarTitle: 'Crop image',
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
