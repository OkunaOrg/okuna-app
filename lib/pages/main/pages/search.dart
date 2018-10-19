import 'package:Openbook/pages/main/widgets/drawer/avatar-drawer-opener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainSearchPageState();
  }
}

class MainSearchPageState extends State<MainSearchPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Search'),
        ),
        child: Center(
          child: TextField(),
        ));
  }
}
