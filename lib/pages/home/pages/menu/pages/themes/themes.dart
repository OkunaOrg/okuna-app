import 'package:Okuna/models/user.dart';
import 'package:Okuna/pages/home/lib/poppable_page_controller.dart';
import 'package:Okuna/pages/home/pages/menu/pages/themes/widgets/curated_themes.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/secondary_text.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBThemesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LocalizationService _localizationService = OpenbookProvider.of(context).localizationService;
    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.drawer__themes,
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                OBCuratedThemes()
              ],
            )),
          ],
        ),
      ),
    );
  }
}
