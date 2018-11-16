import 'package:Openbook/models/post_comment.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class OBExpandedPostComment extends StatelessWidget {
  final PostComment _postComment;

  OBExpandedPostComment(this._postComment);

  @override
  Widget build(BuildContext context) {
    String commenterUsername = _postComment.getCommenterUsername();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OBUserAvatar(
            size: OBUserAvatarSize.medium,
            avatarUrl: _postComment.commenter.profile.avatar,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                  maxLines: null,
                  text: TextSpan(children: [
                    TextSpan(
                        text: commenterUsername,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    TextSpan(text: ' '),
                    TextSpan(
                        text: _postComment.text,
                        style: TextStyle(color: Colors.black87))
                  ])),
              SizedBox(
                height: 5.0,
              ),
              Text(
                _postComment.getRelativeCreated().toUpperCase(),
                style: TextStyle(fontSize: 10.0),
              )
            ],
          ))
        ],
      ),
    );
  }
}
