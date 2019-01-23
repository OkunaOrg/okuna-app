import 'package:Openbook/models/post.dart';
import 'package:Openbook/pages/home/bottom_sheets/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Openbook/widgets/post/widgets/post-body/post_body.dart';
import 'package:Openbook/widgets/post/widgets/post_circles.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Openbook/widgets/post/widgets/post_header.dart';
import 'package:Openbook/widgets/post/widgets/post_reactions/post_reactions.dart';
import 'package:flutter/material.dart';

class OBPost extends StatefulWidget {
  final Post post;
  final OnPostDeleted onPostDeleted;

  const OBPost(this.post, {Key key, @required this.onPostDeleted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBPostState();
  }
}

class OBPostState extends State<OBPost> with AutomaticKeepAliveClientMixin {
  // TODO[HIGH] How should we even use this!? If we just set it always to keep alive
  // does that mean this will cause a memory leak? What the heck are we supposed
  // to do instead? I assumed the Key was meant to tell Flutter the object was
  // the same and not rebuild but wtf!
  // https://github.com/flutter/flutter/issues/20112
  // I've also asked on an issue here
  // https://github.com/flutter/flutter/issues/20112#issuecomment-456228550

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBPostHeader(
          widget.post,
          onPostDeleted: widget.onPostDeleted,
        ),
        OBPostBody(widget.post),
        OBPostReactions(widget.post),
        RepaintBoundary(
          child: OBPostCircles(widget.post),
        ),
        OBPostComments(
          widget.post,
        ),
        OBPostActions(
          widget.post,
        ),
        SizedBox(
          height: 16,
        )
      ],
    );
  }
}
