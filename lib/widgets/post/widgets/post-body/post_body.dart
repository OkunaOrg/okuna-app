import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-body/widgets/post_body_image.dart';
import 'package:Openbook/widgets/post/widgets/post-body/widgets/post_body_text.dart';
import 'package:flutter/material.dart';

class OBPostBody extends StatelessWidget {
  final Post _post;

  OBPostBody(this._post);

  @override
  Widget build(BuildContext context) {
    List<Widget> bodyItems = [];

    if (_post.hasImage()) {
      bodyItems.add(OBPostBodyImage(_post));
    }

    if (_post.hasText()) {
      bodyItems.add(OBPostBodyText(_post));
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bodyItems,
            ),
          )
        )
      ],
    );
  }
}
