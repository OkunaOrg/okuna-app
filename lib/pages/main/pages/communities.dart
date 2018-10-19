import 'package:Openbook/pages/main/widgets/avatar-drawer-opener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainCommunitiesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainCommunitiesPageState();
  }
}

class MainCommunitiesPageState extends State<MainCommunitiesPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Communities'),
        ),
        child: Center(
          child: Text('Communities Page Content'),
        )
    );
  }
}
