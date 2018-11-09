import 'package:Openbook/pages/main/widgets/avatar-drawer-opener.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainHomePageState();
  }
}

class MainHomePageState extends State<MainHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          leading: MainAvatarDrawerOpener(),
          middle: Text('Home'),
          trailing: OBIcon(OBIcons.chat),
        ),
        child: Center(
          child: CupertinoButton(
              child: Text('Push'),
              onPressed: () {
                Navigator.of(context).push(CupertinoPageRoute<void>(
                  title: 'Pushed',
                  builder: (BuildContext context) => CupertinoPageScaffold(
                        navigationBar: CupertinoNavigationBar(),
                        child: Center(
                          child: Text('Hi'),
                        ),
                      ),
                ));
              }),
        ));
  }
}
