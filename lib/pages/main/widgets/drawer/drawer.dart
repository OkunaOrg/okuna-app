import 'package:Openbook/pages/main/widgets/drawer/widgets/body.dart';
import 'package:Openbook/pages/main/widgets/drawer/widgets/footer.dart';
import 'package:Openbook/pages/main/widgets/drawer/widgets/header/header.dart';
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
          MainDrawerHeader(),
          Expanded(child: MainDrawerBody()),
          MainDrawerFooter()
        ],
      ),
    ));
  }
}
