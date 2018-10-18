import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/services/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainDrawerState();
  }
}

class MainDrawerState extends State<MainDrawer> {
  LocalizationService _localizationService;
  UserService _userService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _userService = openbookProvider.userService;

    return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the Drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
      child: Column(
        children: <Widget>[
          _buildDrawerHeader(),
          Expanded(child: _buildDrawerMenuItems()),
          _buildDrawerFooter()
        ],
      ),
    ));
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      child: Container(
        child: Column(),
      ),
    );
  }

  Widget _buildDrawerMenuItems() {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text('Connections'),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Help & Support'),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
        ListTile(
          leading: Icon(Icons.format_paint),
          title: Text('Customize'),
          onTap: () {
            // Update the state of the app
            // ...
          },
        ),
      ],
    );
  }

  Widget _buildDrawerFooter() {
    return ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('Log out'),
      onTap: () {
        // Update the state of the app
        // ...
      },
    );
  }
}
