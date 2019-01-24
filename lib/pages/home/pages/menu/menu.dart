import 'package:Openbook/pages/home/lib/poppable_page_controller.dart';
import 'package:Openbook/pages/home/pages/menu/widgets/curated_themes.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bar.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainMenuPage extends StatelessWidget {
  OBMainMenuPageController controller;

  OBMainMenuPage({this.controller});

  @override
  Widget build(BuildContext context) {
    controller.attach(context: context);
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;
    var userService = openbookProvider.userService;
    var navigationService = openbookProvider.navigationService;

    return CupertinoPageScaffold(
      navigationBar: OBNavigationBar(
        title: 'Menu',
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: OBIcon(OBIcons.circles),
                  title: OBText('My circles'),
                  onTap: () {
                    navigationService.navigateToConnectionsCircles(
                        context: context);
                  },
                ),
                ListTile(
                  leading: OBIcon(OBIcons.lists),
                  title: OBText('My lists'),
                  onTap: () {
                    navigationService.navigateToFollowsLists(context: context);
                  },
                ),
                ListTile(
                  leading: OBIcon(OBIcons.settings),
                  title: OBText(localizationService.trans('DRAWER.SETTINGS')),
                  onTap: () {
                    navigationService.navigateToSettingsPage(context: context);
                  },
                ),
                ListTile(
                  leading: OBIcon(OBIcons.help),
                  title: OBText(localizationService.trans('DRAWER.HELP')),
                  onTap: () {
                    // Update the state of the app
                    // ...
                  },
                ),
                ListTile(
                  leading: OBIcon(OBIcons.logout),
                  title: OBText(localizationService.trans('DRAWER.LOGOUT')),
                  onTap: () {
                    userService.logout();
                  },
                )
              ],
            )),
            OBCuratedThemes()
          ],
        ),
      ),
    );
  }
}

class OBMainMenuPageController extends PoppablePageController {}
