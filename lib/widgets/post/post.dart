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
        OBPostCircles(widget.post),
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
