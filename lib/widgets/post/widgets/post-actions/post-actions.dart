import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post-action-comment.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post-action-react.dart';
import 'package:flutter/material.dart';

class OBPostActions extends StatelessWidget {
  final Post _post;

  OBPostActions(this._post);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: OBPostActionComment(_post),
        ),
        Expanded(
          child: OBPostActionReact(_post),
        )
      ],
    );
  }
}
