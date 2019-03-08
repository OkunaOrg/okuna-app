import 'package:Openbook/pages/home/pages/menu/pages/settings/modals/change-password/change_password.dart';
import 'package:Openbook/pages/home/pages/menu/pages/settings/modals/change_email/change_email.dart';
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
    var localizationService = openbookProvider.localizationService;
    var navigationService = openbookProvider.navigationService;

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
              leading: const OBIcon(OBIcons.email),
              title: OBText(localizationService.trans('SETTINGS.CHANGE_EMAIL')),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => Material(
                          child: OBChangeEmailModal(),
                        )));
              },
            ),
            ListTile(
              leading: const OBIcon(OBIcons.lock),
              title:
                  OBText(localizationService.trans('SETTINGS.CHANGE_PASSWORD')),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => Material(
                          child: OBChangePasswordModal(),
                        )));
              },
            ),
            ListTile(
              leading: const OBIcon(OBIcons.notifications),
              title: OBText('Notifications'),
              onTap: () {
                navigationService.navigateToNotificationsSettings(
                    context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
