import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';

class OBProfileFollowersCount extends StatelessWidget {
  final User user;

  OBProfileFollowersCount(this.user);

  @override
  Widget build(BuildContext context) {
    int followersCount = user.followersCount;

    if (followersCount == null || followersCount == 0 || user.getProfileFollowersCountVisible() == false) return SizedBox();

    String count = getPrettyCount(followersCount);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: count,
                    style: TextStyle(
                        color: Colors.black)),
                TextSpan(text: followersCount == 1 ? ' Follower' : ' Followers', style: TextStyle(color: Colors.black26))
              ])),
        ),
        SizedBox(width: 10,)
      ],
    );
  }
}
