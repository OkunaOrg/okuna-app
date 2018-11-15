import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/main/pages/profile/profile.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final Post _post;

  OBPostHeader(this._post);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          _onWantsPostCreatorProfile(context);
        },
        child: OBUserAvatar(
          size: OBUserAvatarSize.medium,
          avatarUrl: _post.getCreatorAvatar(),
        ),
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
          GestureDetector(
            onTap: () {
              _onWantsPostCreatorProfile(context);
            },
            child: Text(
              _post.getCreatorUsername(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _onWantsPostCreatorProfile(BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => OBProfilePage(_post.creator)));
  }
}
