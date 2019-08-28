import 'dart:io';

import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/media_picker.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class OBImagePickerBottomSheet extends StatelessWidget {
  const OBImagePickerBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = OpenbookProvider.of(context);

    LocalizationService localizationService = provider.localizationService;

    List<Widget> imagePickerActions = [
      ListTile(
        leading: const OBIcon(OBIcons.gallery),
        title: OBText(
          localizationService.image_picker__from_gallery,
        ),
        onTap: () async {
          File file = await FilePicker.getFile(type: FileType.IMAGE);
          Navigator.pop(context, file);
        },
      ),
      ListTile(
        leading: const OBIcon(OBIcons.camera),
        title: OBText(
          localizationService.image_picker__from_camera,
        ),
        onTap: () async {
          File pickedImage =
              await ImagePicker.pickImage(source: ImageSource.camera);
          Navigator.pop(context, pickedImage);
        },
      )
    ];

    return OBPrimaryColorContainer(
        mainAxisSize: MainAxisSize.min,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            children: imagePickerActions,
            mainAxisSize: MainAxisSize.min,
          ),
        ));
  }
}
