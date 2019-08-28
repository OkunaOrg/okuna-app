import 'package:Okuna/pages/home/modals/media_picker/widgets/media_picker_item.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/services/navigation_service.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class OBMediaPickerModal extends StatefulWidget {
  final OBMediaPickerMode mode;

  const OBMediaPickerModal({Key key, this.mode = OBMediaPickerMode.all})
      : super(key: key);

  @override
  OBMediaPickerModalState createState() {
    return OBMediaPickerModalState();
  }
}

class OBMediaPickerModalState extends State<OBMediaPickerModal> {
  LocalizationService _localizationService;
  NavigationService _navigationService;
  bool _needsBootstrap;

  List<AssetEntity> _mediaAssets;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _mediaAssets = [];
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _localizationService = openbookProvider.localizationService;
      _navigationService = openbookProvider.navigationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: _buildGrid(),
        ));
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: _localizationService.media_picker__title,
    );
  }

  Widget _buildGrid() {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return new GridView.builder(
          itemCount: _mediaAssets.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (orientation == Orientation.portrait) ? 4 : 6),
          itemBuilder: _buildGridItem,
        );
      },
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    AssetEntity mediaAsset = _mediaAssets[index];
    return OBMediaPickerItem(
      mediaAsset: mediaAsset,
      onPressed: _onMediaPickerItemPressed,
    );
  }

  void _onMediaPickerItemPressed(AssetEntity mediaAsset) async {
    // Pop the picker with the picked result
    Navigator.pop(context, mediaAsset);
  }

  void _bootstrap() async {
    List<AssetPathEntity> availableMediaCategories;

    switch (widget.mode) {
      case OBMediaPickerMode.all:
        availableMediaCategories = await PhotoManager.getAssetPathList();
        break;
      case OBMediaPickerMode.images:
        availableMediaCategories = await PhotoManager.getImageAsset();
        break;
      case OBMediaPickerMode.videos:
        availableMediaCategories = await PhotoManager.getVideoAsset();
        break;
      default:
        throw Exception('Unkown mode for OBMediaPicker');
    }

    AssetPathEntity allMediaCategoryList = availableMediaCategories[0];
    List<AssetEntity> mediaAssets = await allMediaCategoryList.assetList;

    _setMediaAssets(mediaAssets);
  }

  void _setMediaAssets(List<AssetEntity> mediaAssets) {
    setState(() {
      _mediaAssets = mediaAssets;
    });
  }
}

class OBMediaPickerPermissionDenied implements Exception {
  String cause;

  OBMediaPickerPermissionDenied(this.cause);
}

enum OBMediaPickerMode { images, videos, all }
