import 'package:Openbook/models/post.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostComments extends StatelessWidget {
  final Post _post;

  OBPostComments(this._post);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _post.updateSubject,
      initialData: _post,
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        int commentsCount = _post.commentsCount;
        var openbookProvider = OpenbookProvider.of(context);
        var navigationService = openbookProvider.navigationService;

        bool isClosed = _post.isClosed ?? false;
        bool hasComments = commentsCount != null && commentsCount > 0;
        bool areCommentsEnabled = _post.areCommentsEnabled ?? true;
        bool canDisableOrEnableCommentsForPost = false;

        if (!areCommentsEnabled) {
          canDisableOrEnableCommentsForPost = openbookProvider.userService
              .getLoggedInUser()
              .canDisableOrEnableCommentsForPost(_post);
        }

        List<Widget> rowItems = [];

        if (hasComments) {
          rowItems.add(GestureDetector(
            onTap: () {
              navigationService.navigateToPostComments(
                  post: _post, context: context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: OBSecondaryText('View all $commentsCount comments'),
            ),
          ));
        }

        if (isClosed ||
            (!areCommentsEnabled && canDisableOrEnableCommentsForPost)) {
          List<Widget> secondaryItems = [];

          if (isClosed) {
            secondaryItems.add(Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const OBIcon(
                  OBIcons.closePost,
                  size: OBIconSize.small,
                ),
                const SizedBox(
                  width: 10,
                ),
                const OBSecondaryText('Closed post')
              ],
            ));
          }

          if (!areCommentsEnabled && canDisableOrEnableCommentsForPost) {
            secondaryItems.add(Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const OBIcon(
                  OBIcons.disableComments,
                  size: OBIconSize.small,
                ),
                const SizedBox(
                  width: 10,
                ),
                const OBSecondaryText('Comments disabled')
              ],
            ));
          }

          rowItems.addAll([
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: secondaryItems,
              ),
            )
          ]);
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Row(children: rowItems)],
          ),
        );
      },
    );
  }
}

typedef void OnWantsToSeePostComments(Post post);
