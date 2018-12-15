import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/buttons/button.dart';
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

    return OBButton(
        type: OBButtonType.highlight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OBIcon(
              OBIcons.comment,
              customSize: 20.0,
            ),
            SizedBox(
              width: 10.0,
            ),
            OBText('Comment'),
          ],
        ),
        onPressed: () {
          navigationService.navigateToCommentPost(
              post: _post, context: context);
        });
  }
}

typedef void OnWantsToCommentPost(Post post);
