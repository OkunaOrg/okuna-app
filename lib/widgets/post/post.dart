import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Openbook/widgets/post/widgets/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions.dart';
import 'package:Openbook/widgets/post/widgets/post_timestamp.dart';
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
          OBPostTimestamp(_post),
          OBPostComments(_post),
          OBPostReactions(_post),
          OBPostActions(_post),
        ],
      ),
    );
  }
}
