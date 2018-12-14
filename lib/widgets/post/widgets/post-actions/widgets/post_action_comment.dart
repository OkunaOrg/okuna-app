import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostActionComment extends StatelessWidget {
  final Post _post;

  OBPostActionComment(this._post);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var navigationService = openbookProvider.navigationService;

    return FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OBIcon(OBIcons.comment),
            SizedBox(
              width: 10.0,
            ),
            OBText('Comment'),
          ],
        ),
        color: Color.fromARGB(10, 0, 0, 0),
        onPressed: () {
          navigationService.navigateToCommentPost(
              post: _post, context: context);
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)));
  }
}

typedef void OnWantsToCommentPost(Post post);
