import 'package:Okuna/models/post.dart';
import 'package:Okuna/pages/home/bottom_sheets/post_actions.dart';
import 'package:Okuna/widgets/post/widgets/post_header/widgets/community_post_header/community_post_header.dart';
import 'package:Okuna/widgets/post/widgets/post_header/widgets/user_post_header/user_post_header.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final Post post;
  final OnPostDeleted onPostDeleted;
  final ValueChanged<Post> onPostReported;
  final bool hasActions;
  final bool isTopPost;
  final Function onCommunityExcluded;
  final Function onUndoCommunityExcluded;

  const OBPostHeader(
      {Key key,
      this.onPostDeleted,
      this.post,
      this.onPostReported,
      this.onCommunityExcluded,
      this.onUndoCommunityExcluded,
      this.hasActions = true,
      this.isTopPost = false,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return post.isCommunityPost()
        ? OBCommunityPostHeader(post,
            onPostDeleted: onPostDeleted,
            onPostReported: onPostReported,
            hasActions: hasActions,
            onCommunityExcluded: onCommunityExcluded,
            onUndoCommunityExcluded: onUndoCommunityExcluded,
            isTopPost: isTopPost)
        : OBUserPostHeader(post,
            onPostDeleted: onPostDeleted,
            onPostReported: onPostReported,
            hasActions: hasActions);
  }
}
