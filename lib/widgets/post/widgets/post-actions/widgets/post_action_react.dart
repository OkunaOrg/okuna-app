import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/post_reaction.dart';
import 'package:Openbook/pages/main/modals/react_to_post/react_to_post.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBPostActionReact extends StatelessWidget {
  final Post _post;
  OnPostCreatedCallback onReactedToPost;

  OBPostActionReact(this._post, {this.onReactedToPost});

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
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) {
                return OBReactToPostModal(
                  _post,
                  onReactedToPost: this._onReactedToPost,
                );
              }));
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }

  void _onReactedToPost(PostReaction postReaction) {
    if (this.onReactedToPost != null) this.onReactedToPost(postReaction);
  }
}
