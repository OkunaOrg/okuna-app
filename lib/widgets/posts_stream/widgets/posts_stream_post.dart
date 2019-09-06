import 'package:Okuna/models/post.dart';
import 'package:Okuna/widgets/post/post.dart';
import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';

class OBPostsStreamPost extends StatefulWidget {
  final Post post;
  final String streamIdentifier;
  final ValueChanged<Post> onPostDeleted;

  const OBPostsStreamPost(
      {Key key,
      @required this.post,
      @required this.streamIdentifier,
      this.onPostDeleted})
      : super(key: key);

  @override
  OBPostsStreamPostState createState() {
    return OBPostsStreamPostState();
  }
}

class OBPostsStreamPostState extends State<OBPostsStreamPost> {
  @override
  Widget build(BuildContext context) {
    InViewState state = InViewNotifierList.of(context);
    String inViewId = '${widget.streamIdentifier}_${widget.post.id.toString()}';
    state.addContext(context: context, id: inViewId);

    return OBPost(
      widget.post,
      onPostDeleted: widget.onPostDeleted,
      inViewId: inViewId,
    );
  }
}
