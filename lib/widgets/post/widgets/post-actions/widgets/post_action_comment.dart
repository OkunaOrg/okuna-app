import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostActionComment extends StatelessWidget {
  final Post _post;
  final OnWantsToCommentPost onWantsToCommentPost;

  OBPostActionComment(this._post, {this.onWantsToCommentPost});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OBIcon(OBIcons.comment),
            SizedBox(
              width: 10.0,
            ),
            Text('Comment'),
          ],
        ),
        color: Color.fromARGB(5, 0, 0, 0),
        onPressed: () {
          if (onWantsToCommentPost != null) {
            onWantsToCommentPost(_post);
          }
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }
}

typedef void OnWantsToCommentPost(Post post);
