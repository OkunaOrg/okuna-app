import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/avatars/user-avatar.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final Post _post;

  OBPostHeader(this._post);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: OBUserAvatar(
          size: OBUserAvatarSize.small,
          avatarUrl: _post.getCreatorAvatar(),
        ),
        trailing: Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _post.getCreatorUsername(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
