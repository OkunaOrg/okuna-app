import 'package:Openbook/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostComments extends StatelessWidget {
  final Post _post;
  final OnWantsToSeePostComments onWantsToSeePostComments;

  OBPostComments(this._post, {this.onWantsToSeePostComments});

  @override
  Widget build(BuildContext context) {
    int commentsCount = _post.commentsCount;

    if (commentsCount == null || commentsCount == 0) {
      return SizedBox();
    }

    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              onWantsToSeePostComments(_post);
            },
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text('View all $commentsCount comments'),
            ),
          )
        ],
      ),
    );
  }
}

typedef void OnWantsToSeePostComments(Post post);
