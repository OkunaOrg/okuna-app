import 'dart:io';

import 'package:Openbook/provider.dart';
import 'package:Openbook/services/image_picker.dart';
import 'package:Openbook/services/toast.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBPhotoPickerBottomSheet extends StatelessWidget {
  final OBImageType imageType;

  const OBPhotoPickerBottomSheet({Key key, this.imageType = OBImageType.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImagePickerService imagePickerService =
        OpenbookProvider.of(context).imagePickerService;
    ToastService toastService = OpenbookProvider.of(context).toastService;

    List<Widget> photoPickerActions = [
      ListTile(
        leading: const OBIcon(OBIcons.gallery),
        title: const OBText(
          'From gallery',
        ),
        onTap: () async {
          try {
            File image = await imagePickerService.pickImage(
                imageType: imageType, source: ImageSource.gallery);
            Navigator.pop(context, image);
          } on ImageTooLargeException catch (e) {
            int limit = e.getLimitInMB();
            toastService.error(message: 'Image to large (limit: $limit MB)', context: context);
          }
        },
      ),
      ListTile(
        leading: const OBIcon(OBIcons.camera),
        title: const OBText(
          'From camera',
        ),
        onTap: () async {
          try {
            File image = await imagePickerService.pickImage(
                imageType: imageType, source: ImageSource.camera);
            Navigator.pop(context, image);
          } on ImageTooLargeException catch (e) {
            int limit = e.getLimitInMB();
            toastService.error(message: 'Image to large (limit: $limit MB)', context: context);
          }
        },
      )
    ];

    return OBPrimaryColorContainer(
      mainAxisSize: MainAxisSize.min,
      child: Column(
        children: photoPickerActions,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
