import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/bottom_sheets/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post_header/widgets/community_post_header/community_post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_header/widgets/user_post_header/user_post_header.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final Post post;
  final OnPostDeleted onPostDeleted;
  final ValueChanged<Post> onPostReported;
  final bool hasActions;

  const OBPostHeader(
      {Key key,
      this.onPostDeleted,
      this.post,
      this.onPostReported,
      this.hasActions = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return post.isCommunityPost()
        ? OBCommunityPostHeader(post,
            onPostDeleted: onPostDeleted,
            onPostReported: onPostReported,
            hasActions: hasActions)
        : OBUserPostHeader(post,
            onPostDeleted: onPostDeleted,
            onPostReported: onPostReported,
            hasActions: hasActions);
  }
}
