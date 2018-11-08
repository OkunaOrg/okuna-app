import 'package:Openbook/pages/main/widgets/avatar-drawer-opener.dart';
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
          trailing: Image.asset(
            'assets/images/icons/chat-icon.png',
            height: 20.0,
          ),
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
