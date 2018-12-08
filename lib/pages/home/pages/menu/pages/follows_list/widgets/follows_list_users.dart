import 'package:Openbook/models/follows_list.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/post/widgets/post_comment/post_comment.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBFollowsListUsers extends StatelessWidget {
  final FollowsList followsList;
  final OnWantsToSeeUserProfile onWantsToSeeUserProfile;

  OBFollowsListUsers(this.followsList,
      {@required this.onWantsToSeeUserProfile});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: followsList.updateChange,
        initialData: followsList,
        builder: (BuildContext context, AsyncSnapshot<FollowsList> snapshot) {
          var followsList = snapshot.data;
          List<User> users = followsList.users?.users ?? [];

          return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return OBUserTile(
                  user,
                  showFollowing: false,
                  onUserTilePressed: onWantsToSeeUserProfile,
                );
              });
        });
  }
}
