import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/avatars/user-avatar.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final Post _post;

  OBPostHeader(this._post);

  @override
  Widget build(BuildContext context) {
    var border = BorderSide(
      color: Color.fromARGB(5, 0, 0, 0),
      width: 1.0,
    );

    return Container(
      decoration: BoxDecoration(
        border: Border(top: border),
      ),
      child: ListTile(
        leading: OBUserAvatar(
          size: OBUserAvatarSize.small,
          avatarImage: NetworkImage(_post.getCreatorAvatar()),
        ),
        trailing: Icon(
          Icons.more_vert,
          color: Colors.black,
        ),
        title: Text(
          _post.getCreatorUsername(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
