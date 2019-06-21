import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_circles.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Openbook/widgets/post/widgets/post_header/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/post_reactions.dart';
import 'package:Openbook/widgets/theming/post_divider.dart';
import 'package:flutter/material.dart';


class OBPostPreview extends StatelessWidget {
  final Post post;
  final Function(Post) onPostDeleted;
  final VoidCallback focusCommentInput;
  bool showViewAllCommentsAction = true;
  GlobalKey _keyPostBody = GlobalKey();
  
  OBPostPreview({this.post, this.onPostDeleted, this.focusCommentInput, this.showViewAllCommentsAction});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBPostHeader(
          post: this.post,
          onPostDeleted: this.onPostDeleted,
        ),
        Container(
          key: _keyPostBody,
          child: OBPostBody(this.post),
        ),
        OBPostReactions(this.post),
        showViewAllCommentsAction == true ?
        OBPostComments(
          this.post,
        ) : SizedBox(),
        OBPostCircles(this.post),
        OBPostActions(
          this.post,
          onWantsToCommentPost: this.focusCommentInput,
        ),
        const SizedBox(
          height: 16,
        ),
        OBPostDivider()
      ],
    );
  }
}