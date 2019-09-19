import 'package:Okuna/models/post.dart';
import 'package:Okuna/services/user.dart';
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

import '../../provider.dart';

class OBPost extends StatefulWidget {
  final Post post;
  final ValueChanged<Post> onPostDeleted;
  final OnTextExpandedChange onTextExpandedChange;
  final String inViewId;
  final bool isTopPost;
  final Function onCommunityExcluded;
  final Function onUndoCommunityExcluded;

  const OBPost(this.post,
      {Key key,
        @required this.onPostDeleted,
        this.onCommunityExcluded,
        this.onUndoCommunityExcluded,
        this.onTextExpandedChange,
        this.inViewId,
        this.isTopPost = false})
      : super(key: key);

  @override
  OBPostState createState() {
    return OBPostState();
  }
}

class OBPostState extends State<OBPost> {
  UserService _userService;
  bool _needsBootstrap;
  InViewState _inViewState;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    _userService = OpenbookProvider.of(context).userService;

    if (_needsBootstrap) {
      _bootstrap();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBPostHeader(
          post: widget.post,
          onPostDeleted: widget.onPostDeleted,
          onPostReported: widget.onPostDeleted,
          isTopPost: widget.isTopPost,
          onCommunityExcluded: widget.onCommunityExcluded,
          onUndoCommunityExcluded: widget.onUndoCommunityExcluded,
        ),
        OBPostBody(widget.post,
            onTextExpandedChange: widget.onTextExpandedChange,
            inViewId: widget.inViewId),
        OBPostReactions(widget.post),
        OBPostCircles(widget.post),
        OBPostComments(
          widget.post,
        ),
        OBPostActions(
          widget.post,
        ),
        const SizedBox(
          height: 16,
        ),
        OBPostDivider(),
      ],
    );
  }

  void _bootstrap() {
    if (widget.inViewId != null) {
      _inViewState = InViewNotifierList.of(context);
      String postId = widget.post.id.toString();
      _inViewState.addContext(context: context, id: postId);

      if (widget.isTopPost) {
        print('added listener for ${widget.inViewId}');
        _inViewState.addListener(_onInViewStateChanged);
      }
    }
    _needsBootstrap = false;
  }

  void _onInViewStateChanged() {
    final bool isInView = _inViewState.inView(widget.inViewId);
    print('$isInView, ${widget.inViewId}');
    if (isInView) {
      debugPrint('Setting id ${widget.post.id} as last viewed for top posts');
      print('Setting id ${widget.post.id} as last viewed for top posts');
      _userService.setTopPostsLastViewedId(widget.post.id);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _inViewState?.removeListener(_onInViewStateChanged);
  }
}
