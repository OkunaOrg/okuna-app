import 'package:Okuna/models/post.dart';
import 'package:Okuna/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Okuna/widgets/post/widgets/post-body/post_body.dart';
import 'package:Okuna/widgets/post/widgets/post-body/widgets/post_body_text.dart';
import 'package:Okuna/widgets/post/widgets/post_circles.dart';
import 'package:Okuna/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Okuna/widgets/post/widgets/post_header/post_header.dart';
import 'package:Okuna/widgets/post/widgets/post_reactions.dart';
import 'package:Okuna/widgets/theming/post_divider.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';


class OBPost extends StatelessWidget {
  final Post post;
  final ValueChanged<Post> onPostDeleted;
  final ValueChanged<Post> onPostIsInView;
  final OnTextExpandedChange onTextExpandedChange;
  final String inViewId;
  final bool isTopPost;
  final Function onCommunityExcluded;
  final Function onUndoCommunityExcluded;

  const OBPost(this.post,
      {Key key,
        @required this.onPostDeleted,
        this.onPostIsInView,
        this.onCommunityExcluded,
        this.onUndoCommunityExcluded,
        this.onTextExpandedChange,
        this.inViewId,
        this.isTopPost = false})
      : super(key: key);


  @override
  Widget build(BuildContext context) {

    _bootstrap(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBPostHeader(
          post: post,
          onPostDeleted: onPostDeleted,
          onPostReported: onPostDeleted,
          isTopPost: isTopPost,
          onCommunityExcluded: onCommunityExcluded,
          onUndoCommunityExcluded: onUndoCommunityExcluded,
        ),
        OBPostBody(post,
            onTextExpandedChange: onTextExpandedChange,
            inViewId: inViewId),
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
        ),
        OBPostDivider(),
      ],
    );
  }

  void _bootstrap(BuildContext context) {
    InViewState _inViewState;
    if (inViewId != null) {
      _inViewState = InViewNotifierList.of(context);
      _inViewState.addContext(context: context, id: inViewId);

      if (isTopPost) {
        _inViewState.addListener(() =>_onInViewStateChanged(_inViewState));
      }
    }
  }

  void _onInViewStateChanged(InViewState _inViewState) {
    final bool isInView = _inViewState.inView(inViewId);
    if (isInView) {
      debugPrint('Setting id ${post.id} as last viewed for top posts');
      if (onPostIsInView != null) onPostIsInView(post);
    }
  }
}
