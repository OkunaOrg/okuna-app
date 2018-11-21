import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_comment.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Openbook/widgets/post/widgets/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions.dart';
import 'package:flutter/material.dart';

class OBPost extends StatelessWidget {
  final Post _post;
  final OnWantsToCommentPost onWantsToCommentPost;
  final OnWantsToReactToPost onWantsToReactToPost;

  OBPost(this._post, {this.onWantsToReactToPost, this.onWantsToCommentPost});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OBPostHeader(_post),
          OBPostBody(_post),
          OBPostComments(_post),
          OBPostReactions(_post),
          OBPostActions(
            _post,
            onWantsToCommentPost: onWantsToCommentPost,
            onWantsToReactToPost: onWantsToReactToPost,
          ),
          Divider()
        ],
      ),
    );
  }
}
