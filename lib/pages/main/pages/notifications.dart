import 'package:Openbook/pages/main/widgets/avatar-drawer-opener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainNotificationsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainNotificationsPageState();
  }
}

class MainNotificationsPageState extends State<MainNotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Notifications'),
        ),
        child: Center(
          child: Text('Notifications Page Content'),
        )
    );
  }
}
