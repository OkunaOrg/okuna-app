import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-body/widgets/post_body_image.dart';
import 'package:Openbook/widgets/post/widgets/post-body/widgets/post_body_text.dart';
import 'package:Openbook/widgets/post/widgets/post-body/widgets/post_body_video.dart';
import 'package:flutter/material.dart';

class OBPostBody extends StatefulWidget {
  final Post post;

  const OBPostBody(this.post, {Key key}) : super(key: key);

  @override
  OBPostBodyState createState() {
    return OBPostBodyState();
  }
}

class OBPostBodyState extends State<OBPostBody> {
  @override
  Widget build(BuildContext context) {
    List<Widget> bodyItems = [];

    if (widget.post.hasImage()) {
      bodyItems.add(OBPostBodyImage(
        post: widget.post,
      ));
    } else if (widget.post.hasVideo()) {
      bodyItems.add(OBPostBodyVideo(post: widget.post));
    }

    if (widget.post.hasText()) {
      bodyItems.add(OBPostBodyText(widget.post));
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
