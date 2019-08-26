import 'package:Okuna/pages/home/modals/media_picker/widgets/media_picker_item.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class OBMediaPickerModal extends StatefulWidget {
  @override
  OBMediaPickerModalState createState() {
    return OBMediaPickerModalState();
  }
}

class OBMediaPickerModalState extends State {
  LocalizationService _localizationService;
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
    );
  }

  void _bootstrap() async {
    List<AssetPathEntity> availableMediaCategories =
        await PhotoManager.getAssetPathList();

    AssetPathEntity allMediaCategoryList = availableMediaCategories[0];
    List<AssetEntity> mediaAssets = await allMediaCategoryList.assetList;

    print(mediaAssets);
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
