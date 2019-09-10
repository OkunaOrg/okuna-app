import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:Okuna/widgets/theming/text.dart';
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
      navigationBar: OBThemedNavigationBar(
          title: localizationService.trans('drawer__settings')),
      child: OBPrimaryColorContainer(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: const OBIcon(OBIcons.account),
              title:
                  OBText(localizationService.trans('drawer__account_settings')),
              onTap: () {
                navigationService.navigateToAccountSettingsPage(
                    context: context);
              },
            ),
            ListTile(
              leading: const OBIcon(OBIcons.application),
              title: OBText(
                  localizationService.trans('drawer__application_settings')),
              onTap: () {
                navigationService.navigateToApplicationSettingsPage(
                    context: context);
              },
            ),
            ListTile(
              leading: const OBIcon(OBIcons.bug),
              title: OBText(localizationService.drawer__developer_settings),
              onTap: () {
                navigationService.navigateToDeveloperSettingsPage(
                    context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
