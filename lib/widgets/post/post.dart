import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_circles.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Openbook/widgets/post/widgets/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/post_reactions.dart';
import 'package:flutter/material.dart';

class OBPost extends StatelessWidget {
  final Post _post;

  const OBPost(this._post, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBPostHeader(_post),
        OBPostBody(_post),
        OBPostReactions(_post),
        OBPostCircles(_post),
        OBPostComments(
          _post,
        ),
        OBPostActions(
          _post,
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}
