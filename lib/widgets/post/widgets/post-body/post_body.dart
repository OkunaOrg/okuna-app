import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-body/widgets/post_body_image.dart';
import 'package:Openbook/widgets/post/widgets/post-body/widgets/post_body_text.dart';
import 'package:Openbook/widgets/post/widgets/post-body/widgets/post_body_video.dart';
import 'package:flutter/material.dart';

class OBPostBody extends StatelessWidget {
  final Post post;

  const OBPostBody(this.post, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyItems = [];

    if (post.hasImage()) {
      bodyItems.add(OBPostBodyImage(post));
    } else if (post.hasVideo()) {
      bodyItems.add(OBPostBodyVideo(post: post));
    }

    if (post.hasText()) {
      bodyItems.add(OBPostBodyText(post));
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: bodyItems,
        ))
      ],
    );
  }
}
