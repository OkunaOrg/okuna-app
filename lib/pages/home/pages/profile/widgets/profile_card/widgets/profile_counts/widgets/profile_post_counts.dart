import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';

class OBProfilePostsCount extends StatelessWidget {
  final User user;

  OBProfilePostsCount(this.user);

  @override
  Widget build(BuildContext context) {
    int postsCount = user.postsCount;

    if (postsCount == null || postsCount == 0) return SizedBox();

    String count = getPrettyCount(postsCount);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: RichText(
              text: TextSpan(children: [
            TextSpan(text: count, style: TextStyle(color: Colors.black)),
            TextSpan(
                text: postsCount == 1 ? ' Post' : ' Posts',
                style: TextStyle(color: Colors.black26))
          ])),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
