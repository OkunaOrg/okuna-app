import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/main/main.dart';
import 'package:Openbook/pages/main/pages/home/widgets/home-posts.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainHomePage extends StatelessWidget {
  OBMainPageController mainPageController;
  OBHomePostsController homePostsController;

  OBMainHomePage({this.homePostsController, this.mainPageController});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          middle: Text('Home'),
          trailing: OBIcon(OBIcons.chat),
        ),
        child: Stack(
          children: <Widget>[
            OBHomePosts(
              controller: homePostsController,
            ),
            Positioned(
                bottom: 20.0,
                right: 20.0,
                child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      mainPageController.openCreatePostModal();
                    },
                    child: OBIcon(OBIcons.createPost)))
          ],
        ));
  }
}
