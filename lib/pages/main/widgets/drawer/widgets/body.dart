
import 'package:flutter/material.dart';

class MainDrawerBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

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
}
