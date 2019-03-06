import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/bottom_sheets/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_circles.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Openbook/widgets/post/widgets/post_headers/community_post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_headers/user_post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/post_reactions.dart';
import 'package:flutter/material.dart';

class OBPost extends StatelessWidget {
  final Post post;
  final OnPostReported onPostReported;
  final OnPostDeleted onPostDeleted;

  const OBPost(this.post, {Key key, @required this.onPostDeleted, @required this.onPostReported})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        post.isCommunityPost()
            ? OBCommunityPostHeader(
                post,
                onPostDeleted: onPostDeleted,
                onPostReported: onPostReported
              )
            : OBUserPostHeader(
                post,
                onPostDeleted: onPostDeleted,
                onPostReported: onPostReported,
              ),
        OBPostBody(post),
        OBPostReactions(post),
        OBPostCircles(post),
        OBPostComments(
          post,
        ),
        OBPostActions(
          post,
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }
}
