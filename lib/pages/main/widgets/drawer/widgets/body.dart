import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';

class MainDrawerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;

    double tileIconHeight = 20.0;

    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        ListTile(
          leading: Image.asset(
            'assets/images/icons/profile-icon.png',
            height: tileIconHeight,
          ),
          title: Text(localizationService.trans('DRAWER.PROFILE')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icons/connections-icon.png',
            height: tileIconHeight,
          ),
          title: Text(localizationService.trans('DRAWER.CONNECTIONS')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icons/settings-icon.png',
            height: tileIconHeight,
          ),
          title: Text(localizationService.trans('DRAWER.SETTINGS')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icons/help-icon.png',
            height: tileIconHeight,
          ),
          title: Text(localizationService.trans('DRAWER.HELP')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Image.asset(
            'assets/images/icons/customize-icon.png',
            height: tileIconHeight,
          ),
          title: Text(localizationService.trans('DRAWER.CUSTOMIZE')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
      ],
    );
  }
}
