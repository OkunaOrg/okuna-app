
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';

class MainDrawerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var localizationService = openbookProvider.localizationService;

    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: Text(localizationService.trans('DRAWER.PROFILE')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text(localizationService.trans('DRAWER.CONNECTIONS')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(localizationService.trans('DRAWER.SETTINGS')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text(localizationService.trans('DRAWER.HELP')),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.format_paint),
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
