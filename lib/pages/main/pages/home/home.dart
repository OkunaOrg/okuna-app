import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/main/pages/home/widgets/home-posts.dart';
import 'package:Openbook/pages/main/widgets/avatar-drawer-opener.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainHomePage extends StatelessWidget {
  OBHomePostsController homePostsController;
  User user;

  OBMainHomePage({this.homePostsController});

  @override
  Widget build(BuildContext context) {
    return user != null ? _buildProfile(context, user) : _buildHomePage(context);
  }

  Widget _buildHomePage(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          leading: OBLoggedInUserAvatarDrawerOpener(),
          middle: Text('Home'),
          trailing: OBIcon(OBIcons.chat),
        ),
        child: OBHomePosts(
          controller: homePostsController,
        ));
  }

  Widget _buildProfile(BuildContext context, User user) {

    String username = user.username;

    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              }),
          //leading: OBLoggedInUserAvatarDrawerOpener(),
          middle: Text('Profile'),
          trailing: OBIcon(OBIcons.chat),
        ),
        child: Center(
          child: Text('Profile of $username'),
        ));
  }
}
