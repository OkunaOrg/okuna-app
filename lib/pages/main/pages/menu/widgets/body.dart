import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBMainMenuBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;
    var userService = openbookProvider.userService;

    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        ListTile(
          leading: OBIcon(OBIcons.profile),
          title: Text(localizationService.trans('DRAWER.PROFILE')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: OBIcon(OBIcons.connections),
          title: Text(localizationService.trans('DRAWER.CONNECTIONS')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: OBIcon(OBIcons.settings),
          title: Text(localizationService.trans('DRAWER.SETTINGS')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: OBIcon(OBIcons.help),
          title: Text(localizationService.trans('DRAWER.HELP')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: OBIcon(OBIcons.customize),
          title: Text(localizationService.trans('DRAWER.CUSTOMIZE')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: OBIcon(OBIcons.logout),
          title: Text(localizationService.trans('DRAWER.LOGOUT')),
          onTap: () {
            userService.logout();
          },
        )
      ],
    );
  }
}
