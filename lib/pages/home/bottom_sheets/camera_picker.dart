import 'dart:io';
import 'package:Okuna/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/media.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class OBCameraPickerBottomSheet extends StatelessWidget {
  const OBCameraPickerBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);

    LocalizationService localizationService = provider.localizationService;

    List<Widget> cameraPickerActions = [
      ListTile(
        leading: const OBIcon(OBIcons.camera),
        title: OBText(
          localizationService.post__create_photo,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestStoragePermissions(context: context);
          if (permissionGranted) {
            File file = await ImagePicker.pickImage(source: ImageSource.camera);
            Navigator.pop(
                context, file != null ? Media(file, FileType.image) : null);
          }
        },
      ),
      ListTile(
        leading: const OBIcon(OBIcons.video_camera),
        title: OBText(
          localizationService.post__create_video,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestStoragePermissions(context: context);
          if (permissionGranted) {
            File file = await ImagePicker.pickVideo(source: ImageSource.camera);
            Navigator.pop(
                context, file != null ? Media(file, FileType.video) : null);
          }
        },
      ),
    ];

    return OBRoundedBottomSheet(
        child: Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        children: cameraPickerActions,
        mainAxisSize: MainAxisSize.min,
      ),
    ));
  }
}
