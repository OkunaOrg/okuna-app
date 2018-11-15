import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post_comments/widgets/post_comment.dart';
import 'package:flutter/material.dart';

class OBPostComments extends StatelessWidget {
  final Post _post;

  OBPostComments(this._post);

  @override
  Widget build(BuildContext context) {

    if (!_post.hasComments()) return SizedBox();

    List<Widget> posts = [];

    _post.getPostComments().forEach((postComment) {
      posts.add(OBPostComment(postComment));
    });

    return Column(
      children: posts,
    );
  }
}
