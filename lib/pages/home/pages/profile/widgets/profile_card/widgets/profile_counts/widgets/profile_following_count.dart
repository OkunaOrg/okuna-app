import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';

class OBProfileFollowingCount extends StatelessWidget {
  final User user;

  OBProfileFollowingCount(this.user);

  @override
  Widget build(BuildContext context) {
    int followingCount = user.followingCount;

    if (followingCount == null || followingCount == 0) return SizedBox();

    String count = getPrettyCount(followingCount);

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
                TextSpan(text: ' Following', style: TextStyle(color: Colors.black26))
              ])),
        ),
        SizedBox(width: 10,)
      ],
    );
  }
}
