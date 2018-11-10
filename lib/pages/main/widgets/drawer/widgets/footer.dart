import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';

class OBMainDrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;
    var localizationService = openbookProvider.localizationService;

    double tileIconHeight = 20.0;

    return ListTile(
      leading: Image.asset(
        'assets/images/icons/logout-icon.png',
        height: tileIconHeight,
      ),
      title: Text(localizationService.trans('DRAWER.LOGOUT')),
      onTap: () {
        userService.logout();
      },
    );
  }
}
