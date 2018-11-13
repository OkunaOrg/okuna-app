import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainCommunitiesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBMainCommunitiesPageState();
  }
}

class OBMainCommunitiesPageState extends State<OBMainCommunitiesPage> {
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
