import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var navigationService = openbookProvider.navigationService;
    var localizationService = openbookProvider.localizationService;

    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar: OBThemedNavigationBar(title: 'Settings'),
      child: OBPrimaryColorContainer(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: const OBIcon(OBIcons.account),
              title: OBText(localizationService.trans('DRAWER.SETTINGS')),
              onTap: () {
                navigationService.navigateToAccountSettingsPage(
                    context: context);
              },
            ),
            ListTile(
              leading: const OBIcon(OBIcons.application),
              title: OBText('Application settings'),
              onTap: () {
                navigationService.navigateToApplicationSettingsPage(
                    context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
