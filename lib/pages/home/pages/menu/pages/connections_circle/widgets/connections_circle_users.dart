import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBConnectionsCircleUsers extends StatelessWidget {
  final Circle connectionsCircle;

  OBConnectionsCircleUsers(this.connectionsCircle);

  @override
  Widget build(BuildContext context) {
    var navigationService = OpenbookProvider.of(context).navigationService;

    return StreamBuilder(
        stream: connectionsCircle.updateSubject,
        initialData: connectionsCircle,
        builder: (BuildContext context, AsyncSnapshot<Circle> snapshot) {
          var connectionsCircle = snapshot.data;
          List<User> users = connectionsCircle.users?.users ?? [];

          var onUserTilePressed = (User user) {
            navigationService.navigateToUserProfile(
                user: user, context: context);
          };

          return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];

                Widget trailing;
                bool isFullyConnected = user.isFullyConnected ?? true;

                if (!isFullyConnected) {
                  trailing = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[const OBText('Pending')],
                  );
                }

                return OBUserTile(
                  user,
                  showFollowing: false,
                  onUserTilePressed: onUserTilePressed,
                  trailing: trailing,
                );
              });
        });
  }
}
