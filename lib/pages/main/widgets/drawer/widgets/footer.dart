import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';

class MainDrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;
    var localizationService = openbookProvider.localizationService;

    return ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text(localizationService.trans('DRAWER.LOGOUT')),
      onTap: () {
        userService.logout();
      },
    );
  }
}
