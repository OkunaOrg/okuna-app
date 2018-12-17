import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/modals/create_post/create_post.dart';
import 'package:Openbook/pages/home/modals/edit_user_profile/edit_user_profile.dart';
import 'package:Openbook/pages/home/modals/react_to_post/react_to_post.dart';
import 'package:Openbook/pages/home/modals/save_connections_circle.dart';
import 'package:Openbook/pages/home/modals/save_follows_list/save_follows_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalService {
  Future<Post> openCreatePost({@required BuildContext context}) async {
    Post createdPost = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<Post>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Material(
                child: CreatePostModal(),
              );
            }));

    return createdPost;
  }

  Future<PostReaction> openReactToPost(
      {@required Post post, @required BuildContext context}) async {
    PostReaction postReaction = await Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<PostReaction>(
            fullscreenDialog: true,
            builder: (BuildContext context) => Material(
                  child: OBReactToPostModal(post),
                )));

    return postReaction;
  }

  Future<void> openEditUserProfile(
      {@required User user, @required BuildContext context}) async {
    Navigator.of(context, rootNavigator: true)
        .push(CupertinoPageRoute<PostReaction>(
            fullscreenDialog: true,
            builder: (BuildContext context) => Material(
                  child: OBEditUserProfileModal(user),
                )));
  }

  Future<FollowsList> openCreateFollowsList(
      {@required BuildContext context}) async {
    FollowsList createdFollowsList =
        await Navigator.of(context, rootNavigator: true)
            .push(CupertinoPageRoute<FollowsList>(
                fullscreenDialog: true,
                builder: (BuildContext context) {
                  return OBSaveFollowsListModal(
                    autofocusNameTextField: true,
                  );
                }));

    return createdFollowsList;
  }

  Future<FollowsList> openEditFollowsList(
      {@required FollowsList followsList,
      @required BuildContext context}) async {
    FollowsList editedFollowsList =
        await Navigator.of(context).push(CupertinoPageRoute<FollowsList>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBSaveFollowsListModal(
                followsList: followsList,
              );
            }));

    return editedFollowsList;
  }

  Future<Circle> openCreateConnectionsCircle(
      {@required BuildContext context}) async {
    Circle createdConnectionsCircle =
        await Navigator.of(context).push(CupertinoPageRoute<Circle>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBSaveConnectionsCircleModal(
                autofocusNameTextField: true,
              );
            }));

    return createdConnectionsCircle;
  }

  Future<Circle> openEditConnectionsCircle(
      {@required Circle connectionsCircle,
      @required BuildContext context}) async {
    Circle editedConnectionsCircle =
        await Navigator.of(context).push(CupertinoPageRoute<Circle>(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return OBSaveConnectionsCircleModal(
                connectionsCircle: connectionsCircle,
              );
            }));

    return editedConnectionsCircle;
  }
}
