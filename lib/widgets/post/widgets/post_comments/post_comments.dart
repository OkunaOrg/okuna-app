import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/main/pages/post/post.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/widgets/post_comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostComments extends StatelessWidget {
  final Post _post;

  OBPostComments(this._post);

  @override
  Widget build(BuildContext context) {
    bool hasCommentsCount = _post.hasCommentsCount();
    bool hasComments = _post.hasComments();

    if (!hasCommentsCount && !hasComments) {
      return SizedBox();
    }

    List<Widget> postComments = [];

    if (hasComments) {
      _post.getPostComments().forEach((postComment) {
        postComments.add(OBPostComment(postComment));
      });
    }

    if (hasCommentsCount) {
      int commentsCount = _post.commentsCount;
      postComments.add(GestureDetector(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute<void>(
              builder: (BuildContext context) => Material(
                    child: OBPostPage(_post),
                  )));
        },
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text('View all $commentsCount comments'),
        ),
      ));
    }

    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: postComments,
      ),
    );
  }
}
