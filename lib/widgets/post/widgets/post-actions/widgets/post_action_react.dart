import 'package:Openbook/models/post.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBPostActionReact extends StatelessWidget {
  final Post _post;
  OnWantsToReactToPost onWantsToReactToPost;

  OBPostActionReact(this._post, {this.onWantsToReactToPost});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OBIcon(OBIcons.react),
            SizedBox(
              width: 10.0,
            ),
            Text('React'),
          ],
        ),
        color: Color.fromARGB(5, 0, 0, 0),
        onPressed: () {
          if (onWantsToReactToPost != null) {
            onWantsToReactToPost(_post);
          }
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }
}

typedef void OnWantsToReactToPost(Post post);
