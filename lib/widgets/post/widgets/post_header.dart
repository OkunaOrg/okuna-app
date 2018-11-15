import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final Post _post;

  OBPostHeader(this._post);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: OBUserAvatar(
        size: OBUserAvatarSize.medium,
        avatarUrl: _post.getCreatorAvatar(),
      ),
      trailing: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          onPressed: () {}),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _post.getCreatorUsername(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
