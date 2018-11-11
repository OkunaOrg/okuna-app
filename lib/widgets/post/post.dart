import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post-actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post-body.dart';
import 'package:Openbook/widgets/post/widgets/post-comments/post-comments.dart';
import 'package:Openbook/widgets/post/widgets/post-header.dart';
import 'package:Openbook/widgets/post/widgets/post-reactions.dart';
import 'package:flutter/material.dart';

class OBPost extends StatelessWidget {
  final Post _post;

  OBPost(this._post);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          OBPostHeader(_post),
          OBPostBody(_post),
          OBPostComments(_post),
          OBPostReactions(_post),
          OBPostActions(_post),
        ],
      ),
    );
  }
}
