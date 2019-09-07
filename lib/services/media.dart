import 'dart:io';
import 'package:Okuna/plugins/image_converter/image_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:meta/meta.dart';
import 'package:Okuna/services/validation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import 'bottom_sheet.dart';
export 'package:image_picker/image_picker.dart';

class MediaService {
  static Uuid _uuid = new Uuid();

  static const Map IMAGE_RATIOS = {
    OBImageType.avatar: {'x': 1.0, 'y': 1.0},
    OBImageType.cover: {'x': 16.0, 'y': 9.0}
  };

  ValidationService _validationService;
  BottomSheetService _bottomSheetService;

  void setValidationService(ValidationService validationService) {
    _validationService = validationService;
  }

  void setBottomSheetService(BottomSheetService modalService) {
    _bottomSheetService = modalService;
  }

  Future<File> pickImage(
      {@required OBImageType imageType, @required BuildContext context}) async {
    File pickedImage =
        await _bottomSheetService.showImagePicker(context: context);

    if (pickedImage == null) return null;

    List<int> convertedImageData =
        await ImageConverter.convertImage(pickedImage.readAsBytesSync());

    String tmpImageName = _uuid.v4() + '.jpg';
    final path = await _getTempPath();
    final file = File('$path/$tmpImageName');
    file.writeAsBytesSync(convertedImageData);

    if (!await _validationService.isImageAllowedSize(file, imageType)) {
      throw ImageTooLargeException(
          _validationService.getAllowedImageSize(imageType));
    }

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

  Future<File> pickVideo({@required BuildContext context}) async {
    File pickedVideo =
        await _bottomSheetService.showVideoPicker(context: context);

    if (pickedVideo == null) return null;
    String videoExtension = basename(pickedVideo.path);
    String tmpImageName = _uuid.v4() + videoExtension;
    final path = await _getTempPath();
    final String pickedVideoCopyPath = '$path/$tmpImageName';
    File pickedVideoCopy = await pickedVideo.copy(pickedVideoCopyPath);

    return pickedVideoCopy;
  }

  Future<File> processImage(File image) async {
    /// Fix rotation issue on android
    if (Platform.isAndroid)
      return await FlutterExifRotation.rotateImage(path: image.path);
    return image;
  }

  Future<String> _getTempPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> getVideoThumbnail(File videoFile) async {
    final thumbnailData = await VideoThumbnail.thumbnailData(
      video: videoFile.path,
      imageFormat: ImageFormat.JPEG,
      maxHeightOrWidth: 500,
      quality: 100,
    );

    String videoExtension = basename(videoFile.path);
    String tmpImageName = 'thumbnail_' + _uuid.v4() + videoExtension;
    final tempPath = await _getTempPath();
    final String thumbnailPath = '$tempPath/$tmpImageName';
    final file = File(thumbnailPath);
    file.writeAsBytesSync(thumbnailData);

    return file;
  }

  Future<File> compressVideo(File video) async {
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

    String resultFileName = _uuid.v4() + '.mp4';
    final path = await _getTempPath();
    final String resultFilePath = '$path/$resultFileName';
    var arguments = ["-i", video.path, resultFilePath];
    await _flutterFFmpeg.executeWithArguments(arguments);

    File resultFile = File(resultFilePath);

    return resultFile;
  }

  Future<File> compressImage(File image) async {
    List<int> compressedImageData = await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      quality: 80,
    );

    String imageExtension = basename(image.path);
    String tmpImageName = 'compressed_image_' + _uuid.v4() + imageExtension;
    final tempPath = await _getTempPath();
    final String thumbnailPath = '$tempPath/$tmpImageName';
    final file = File(thumbnailPath);
    file.writeAsBytesSync(compressedImageData);

    return file;
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