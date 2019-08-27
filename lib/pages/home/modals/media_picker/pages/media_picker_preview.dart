import 'dart:io';

import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

class OBMediaPickerPreviewPage extends StatefulWidget {
  final AssetEntity mediaAsset;

  const OBMediaPickerPreviewPage({Key key, @required this.mediaAsset})
      : super(key: key);

  @override
  OBMediaPickerPreviewPageState createState() {
    return OBMediaPickerPreviewPageState();
  }
}

class OBMediaPickerPreviewPageState extends State<OBMediaPickerPreviewPage> {
  bool _needsBootstrap;
  LocalizationService _localizationService;
  File _mediaFile;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _localizationService = openbookProvider.localizationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
            child: widget.mediaAsset.type == AssetType.image
                ? _buildMediaAssetImagePreview()
                : _buildMediaAssetVideoPreview()));
  }

  void _bootstrap() async {
    File file = await widget.mediaAsset.file;
    setState(() {
      _mediaFile = file;
    });
  }

  Widget _buildMediaAssetImagePreview() {
    return PhotoView(
      backgroundDecoration: BoxDecoration(color: Colors.transparent),
      enableRotation: false,
      imageProvider: FileImage(_mediaFile),
      maxScale: PhotoViewComputedScale.covered,
      minScale: PhotoViewComputedScale.contained,
    );
  }

  Widget _buildMediaAssetVideoPreview() {}

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
        title: _localizationService.media_picker__title,
        trailing: GestureDetector(
          onTap: _onChoose,
          child: OBText(_localizationService.media_picker__choose_action),
        ));
  }

  void _onChoose() {
    Navigator.pop(context, widget.mediaAsset);
  }
}
