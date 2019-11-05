import 'dart:io';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/media.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class OBVideoPickerBottomSheet extends StatelessWidget {
  const OBVideoPickerBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);

    LocalizationService localizationService = provider.localizationService;

    List<Widget> videoPickerActions = [
      ListTile(
        leading: const OBIcon(OBIcons.gallery),
        title: OBText(
          localizationService.video_picker__from_gallery,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestStoragePermissions(context: context);
          if (permissionGranted) {
            File file = await FilePicker.getFile(type: FileType.VIDEO);
            Navigator.pop(context, file);
          }
        },
      ),
      ListTile(
        leading: const OBIcon(OBIcons.camera),
        title: OBText(
          localizationService.video_picker__from_camera,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestCameraPermissions(context: context);
          if (permissionGranted) {
            File pickedVideo =
                await ImagePicker.pickVideo(source: ImageSource.camera);
            Navigator.pop(context, pickedVideo);
          }
        },
      )
    ];

    return OBPrimaryColorContainer(
        mainAxisSize: MainAxisSize.min,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            children: videoPickerActions,
            mainAxisSize: MainAxisSize.min,
          ),
        ));
  }
}
