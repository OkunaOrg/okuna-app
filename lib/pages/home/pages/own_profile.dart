import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/profile.dart';
import 'package:Openbook/pages/home/pages/post/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBOwnProfilePage extends StatelessWidget {
  final OnWantsToReactToPost onWantsToReactToPost;
  final OBProfilePageController profilePageController;

  OBOwnProfilePage({this.onWantsToReactToPost, this.profilePageController});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    return StreamBuilder(
      stream: userService.loggedInUserChange,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var data = snapshot.data;
        if (data == null) return SizedBox();
        return OBProfilePage(
          data,
          controller: profilePageController,
          onWantsToReactToPost: onWantsToReactToPost,
          onWantsToSeeUserProfile: (User user) =>
              _onWantsToSeeUserProfile(context, user),
          onWantsToSeePostComments: (Post post) =>
              _onWantsToSeePostComments(context, post),
          onWantsToCommentPost: (Post post) =>
              _onWantsToCommentPost(context, post),
        );
      },
    );
  }

  void _onWantsToSeeUserProfile(BuildContext context, User user) {
    Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBProfilePage(user,
                  onWantsToSeeUserProfile: (User user) =>
                      _onWantsToSeeUserProfile(context, user),
                  onWantsToSeePostComments: (Post post) =>
                      _onWantsToSeePostComments(context, post),
                  onWantsToCommentPost: (Post post) =>
                      _onWantsToCommentPost(context, post),
                  onWantsToReactToPost: onWantsToReactToPost),
            )));
  }

  void _onWantsToCommentPost(BuildContext context, Post post) {
    Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBPostPage(post,
                  autofocusCommentInput: true,
                  onWantsToReactToPost: onWantsToReactToPost),
            )));
  }

  void _onWantsToSeePostComments(BuildContext context, Post post) {
    Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => Material(
              child: OBPostPage(post,
                  autofocusCommentInput: false,
                  onWantsToReactToPost: onWantsToReactToPost),
            )));
  }
}
