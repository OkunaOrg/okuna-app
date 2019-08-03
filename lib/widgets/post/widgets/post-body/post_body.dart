import 'package:Okuna/models/post.dart';
import 'package:Okuna/widgets/post/widgets/post-body/widgets/post_body_image.dart';
import 'package:Okuna/widgets/post/widgets/post-body/widgets/post_body_text.dart';
import 'package:Okuna/widgets/post/widgets/post-body/widgets/post_body_video.dart';
import 'package:flutter/material.dart';

class OBPostBody extends StatelessWidget {
  final Post post;
  final OnTextExpandedChange onTextExpandedChange;

  const OBPostBody(this.post, {Key key, this.onTextExpandedChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyItems = [];

    if (post.hasImage()) {
      bodyItems.add(OBPostBodyImage(
        post: post,
      ));
    } else if (post.hasVideo()) {
      bodyItems.add(OBPostBodyVideo(post: post));
    }

    if (post.hasText()) {
      bodyItems.add(OBPostBodyText(
        post,
        onTextExpandedChange: onTextExpandedChange,
      ));
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
