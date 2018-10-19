import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';

class MainDrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    return ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('Log out'),
      onTap: () {
        userService.logout();
      },
    );
  }
}
