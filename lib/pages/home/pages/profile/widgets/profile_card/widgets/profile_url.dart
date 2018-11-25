import 'package:Openbook/models/user.dart';
import 'package:flutter/material.dart';

class OBProfileUrl extends StatelessWidget {
  User user;

  OBProfileUrl(this.user);

  @override
  Widget build(BuildContext context) {
    String url = user.getProfileUrl();

    if (url == null) {
      return SizedBox();
    }

    Color color = Colors.black45;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.link,
          size: 14,
          color: color,
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
            child: Text(
              url,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color),
            )
        )
      ],
    );
  }
}
