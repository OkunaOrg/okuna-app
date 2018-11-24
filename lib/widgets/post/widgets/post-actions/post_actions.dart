import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_comment.dart';
import 'package:Openbook/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:flutter/material.dart';

class OBPostActions extends StatelessWidget {
  final Post _post;
  final OnWantsToCommentPost onWantsToCommentPost;
  final OnWantsToReactToPost onWantsToReactToPost;

  OBPostActions(this._post,
      {this.onWantsToCommentPost, this.onWantsToReactToPost});

  @override
  Widget build(BuildContext context) {
    var labelColor = Colors.black38;

    return Container(
        padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(),
                  ),
                  SizedBox(width: 20.0),
                  _post.hasPublicInteractions()
                      ? Icon(
                          Icons.visibility,
                          size: 15.0,
                          color: labelColor,
                        )
                      : Icon(
                          Icons.visibility_off,
                          size: 15.0,
                          color: labelColor,
                        ),
                  SizedBox(width: 10.0),
                  Text(_post.hasPublicInteractions() ? 'Public' : 'Private',
                      style: TextStyle(
                          fontSize: 12,
                          color: labelColor,
                          fontWeight: FontWeight.bold)),
                  SizedBox(width: 20.0),
                  Expanded(
                    child: Divider(),
                  )
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                    child: OBPostActionReact(_post,
                        onWantsToReactToPost: onWantsToReactToPost)),
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                  child: OBPostActionComment(_post,
                      onWantsToCommentPost: onWantsToCommentPost),
                ),
              ],
            )
          ],
        ));
  }
}
