import 'package:Openbook/pages/main/pages/home/widgets/home-posts.dart';
import 'package:Openbook/pages/main/widgets/avatar-drawer-opener.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBMainHomePageState();
  }
}

class OBMainHomePageState extends State<OBMainHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          leading: OBLoggedInUserAvatarDrawerOpener(),
          middle: Text('Home'),
          trailing: OBIcon(OBIcons.chat),
        ),
        child: OBHomePosts());
  }
}
