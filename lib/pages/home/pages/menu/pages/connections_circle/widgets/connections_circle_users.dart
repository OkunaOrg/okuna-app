import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/post/widgets/post_comment/post_comment.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBConnectionsCircleUsers extends StatelessWidget {
  final Circle connectionsCircle;
  final OnWantsToSeeUserProfile onWantsToSeeUserProfile;

  OBConnectionsCircleUsers(this.connectionsCircle,
      {@required this.onWantsToSeeUserProfile});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connectionsCircle.updateSubject,
        initialData: connectionsCircle,
        builder: (BuildContext context, AsyncSnapshot<Circle> snapshot) {
          var connectionsCircle = snapshot.data;
          List<User> users = connectionsCircle.users?.users ?? [];

          return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];

                Widget trailing;
                bool isFullyConnected = user.isFullyConnected;

                if (!isFullyConnected) {
                  trailing = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[OBText('Pending')],
                  );
                }

                return OBUserTile(
                  user,
                  showFollowing: false,
                  onUserTilePressed: onWantsToSeeUserProfile,
                  trailing: trailing,
                );
              });
        });
  }
}
