import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/tiles/actions/clear_application_cache_tile.dart';
import 'package:Okuna/widgets/tiles/actions/clear_application_preferences_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBApplicationSettingsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar: OBThemedNavigationBar(title: 'Application settings'),
      child: OBPrimaryColorContainer(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            OBClearApplicationCacheTile(),
            OBClearApplicationPreferencesTile(),
          ],
        ),
      ),
    );
  }
}
