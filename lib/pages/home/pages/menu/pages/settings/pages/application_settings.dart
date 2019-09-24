import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/tile_group_title.dart';
import 'package:Okuna/widgets/tiles/actions/clear_application_cache_tile.dart';
import 'package:Okuna/widgets/tiles/actions/clear_application_preferences_tile.dart';
import 'package:Okuna/widgets/tiles/actions/link_previews_setting_tile.dart';
import 'package:Okuna/widgets/tiles/actions/videos_autoplay_setting_tile.dart';
import 'package:Okuna/widgets/tiles/actions/videos_sound_setting_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBApplicationSettingsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    LocalizationService _localizationService =
        OpenbookProvider.of(context).localizationService;

    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar: OBThemedNavigationBar(
          title: _localizationService.drawer__application_settings),
      child: OBPrimaryColorContainer(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          // Important: Remove any padding from the ListView.
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: OBTileGroupTitle(
                title: _localizationService.application_settings__videos,
              ),
            ),
            OBVideosSoundSettingTile(),
            OBVideosAutoPlaySettingTile(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: OBTileGroupTitle(
                title: _localizationService.application_settings__link_previews,
              ),
            ),
            OBLinkPreviewsSettingTile(),
          ],
        ),
      ),
    );
  }
}
