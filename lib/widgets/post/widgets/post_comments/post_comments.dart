import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostComments extends StatelessWidget {
  final Post _post;

  OBPostComments(this._post);

  @override
  Widget build(BuildContext context) {
    int commentsCount = _post.commentsCount;
    var openbookProvider = OpenbookProvider.of(context);
    var navigationService = openbookProvider.navigationService;

    if (commentsCount == null || commentsCount == 0) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              navigationService.navigateToPostComments(
                  post: _post, context: context);
            },
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: OBSecondaryText('View all $commentsCount comments'),
            ),
          )
        ],
      ),
    );
  }
}

typedef void OnWantsToSeePostComments(Post post);
