import 'package:Openbook/pages/main/widgets/drawer/widgets/header/widgets/accounts.dart';
import 'package:Openbook/pages/main/widgets/drawer/widgets/header/widgets/user-overview.dart';
import 'package:flutter/material.dart';

class MainDrawerHeader extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Container(
        child: Column(
          children: <Widget>[
            MainDrawerHeaderAccounts(),
            SizedBox(height: 10.0),
            MainDrawerHeaderUserOverview()],
        ),
      ),
    );
  }
}