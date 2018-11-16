import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class OBPostComment extends StatelessWidget {
  final PostComment _postComment;

  OBPostComment(this._postComment);

  @override
  Widget build(BuildContext context) {
    String commenterUsername = _postComment.getCommenterUsername();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OBUserAvatar(
            size: OBUserAvatarSize.small,
            avatarUrl: _postComment.commenter.profile.avatar,
          ),
          SizedBox(
            width: 10.0,
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: commenterUsername,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87)),
            TextSpan(text: ' '),
            TextSpan(
                text: _postComment.text,
                style: TextStyle(color: Colors.black87))
          ]))
        ],
      ),
    );
  }
}
