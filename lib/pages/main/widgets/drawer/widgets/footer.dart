import 'package:flutter/material.dart';

class MainDrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
