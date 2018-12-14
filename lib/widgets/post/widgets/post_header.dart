import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/post/widgets/post_comment/post_comment.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final Post _post;

  OBPostHeader(this._post);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;
    var navigationService = openbookProvider.navigationService;

    User user = userService.getLoggedInUser();

    bool isPostOwner = user.id == _post.getCreatorId();

    return ListTile(
      leading: StreamBuilder(
          stream: _post.creator.updateSubject,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            var postCreator = snapshot.data;

            if (postCreator == null) return SizedBox();

            return OBUserAvatar(
              onPressed: () {
                navigationService.navigateToUserProfile(
                    user: postCreator, context: context);
              },
              size: OBUserAvatarSize.medium,
              avatarUrl: postCreator.getProfileAvatar(),
            );
          }),
      trailing: IconButton(
          icon: OBIcon(OBIcons.moreVertical),
          onPressed: () {
            showCupertinoModalPopup(
                builder: (BuildContext context) {
                  List<Widget> postActions = [];

                  if (isPostOwner) {
                    postActions.add(CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      child: Text(
                        'Delete post',
                      ),
                      onPressed: () {
                        print('Wants to delete post');
                      },
                    ));
                  } else {
                    postActions.add(CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      child: Text(
                        'Report post',
                      ),
                      onPressed: () {
                        print('Wants to report post');
                      },
                    ));
                  }

                  return CupertinoActionSheet(
                    actions: postActions,
                    cancelButton: CupertinoActionSheetAction(
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black87),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
                context: context);
          }),
      title: GestureDetector(
        onTap: () {
          navigationService.navigateToUserProfile(
              user: _post.creator, context: context);
        },
        child: StreamBuilder(
            stream: _post.creator.updateSubject,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              var postCreator = snapshot.data;

              if (postCreator == null) return SizedBox();

              return OBText(
                postCreator.username,
                style: TextStyle(fontWeight: FontWeight.bold),
              );
            }),
      ),
      subtitle: OBSecondaryText(
        _post.getRelativeCreated(),
        style: TextStyle(fontSize: 12.0),
      ),
    );
  }
}
