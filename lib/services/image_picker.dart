import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

export 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static const Map IMAGE_RATIOS = {
    OBImageType.avatar: {'x': 1.0, 'y': 1.0},
    OBImageType.cover: {'x': 16.0, 'y': 9.0}
  };

  Future<File> pickImage(
      {@required OBImageType imageType,
      ImageSource source = ImageSource.gallery}) async {
    var image = await ImagePicker.pickImage(source: source);

    if (image == null) {
      return null;
    }

    if (imageType == OBImageType.post) return image;

    double ratioX = IMAGE_RATIOS[imageType]['x'];
    double ratioY = IMAGE_RATIOS[imageType]['y'];
    File croppedFile = await ImageCropper.cropImage(
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

enum OBImageType { avatar, cover, post }
