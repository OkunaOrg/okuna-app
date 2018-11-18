import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/main/pages/post/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostComments extends StatelessWidget {
  final Post _post;

  OBPostComments(this._post);

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
              Navigator.of(context).push(CupertinoPageRoute<void>(
                  builder: (BuildContext context) => Material(
                        child: OBPostPage(_post),
                      )));
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
