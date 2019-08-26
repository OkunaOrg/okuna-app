import 'package:Okuna/models/post.dart';
import 'package:Okuna/models/post_image.dart';
import 'package:Okuna/models/post_media.dart';
import 'package:Okuna/models/post_video.dart';
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

    if (post.hasMedia()) {
      PostMedia postMediaFirstItem = post.getFirstMedia();
      Widget mediaWidget;

      switch (postMediaFirstItem.contentObject.runtimeType) {
        case PostImage:
          mediaWidget = OBPostBodyImage(
            postImage: postMediaFirstItem.contentObject,
          );
          break;
        case PostVideo:
          mediaWidget =
              OBPostBodyVideo(postVideo: postMediaFirstItem.contentObject);
          break;
        default:
      }

      if (mediaWidget != null) bodyItems.add(mediaWidget);
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
