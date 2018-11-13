import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainNotificationsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBMainNotificationsPageState();
  }
}

class OBMainNotificationsPageState extends State<OBMainNotificationsPage> {
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
