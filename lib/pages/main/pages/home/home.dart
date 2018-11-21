import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/main/main.dart';
import 'package:Openbook/pages/main/pages/home/widgets/home-posts.dart';
import 'package:Openbook/pages/main/pages/post/post.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMainHomePage extends StatelessWidget {
  final OBMainPageController mainPageController;
  final OBHomePostsController homePostsController;
  final OnWantsToReactToPost onWantsToReactToPost;

  OBMainHomePage(
      {this.homePostsController,
      this.mainPageController,
      this.onWantsToReactToPost});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          backgroundColor: Colors.white,
          middle: Text(
            'Home',
          ),
        ),
        child: Stack(
          children: <Widget>[
            OBHomePosts(
              controller: homePostsController,
              onWantsToReactToPost: onWantsToReactToPost,
              onWantsToCommentPost: (Post post) {
                Navigator.of(context).push(CupertinoPageRoute<void>(
                    builder: (BuildContext context) => Material(
                          child: OBPostPage(post,
                              autofocusCommentInput: true,
                              onWantsToReactToPost: onWantsToReactToPost),
                        )));
              },
              onWantsToSeePostComments: (Post post) {
                Navigator.of(context).push(CupertinoPageRoute<void>(
                    builder: (BuildContext context) => Material(
                          child: OBPostPage(post,
                              autofocusCommentInput: false,
                              onWantsToReactToPost: onWantsToReactToPost),
                        )));
              },
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
