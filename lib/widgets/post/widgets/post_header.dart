import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/main/pages/profile/profile.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final Post _post;

  OBPostHeader(this._post);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;

    User user = userService.getLoggedInUser();

    bool isPostOwner = user.id == _post.getCreatorId();

    return ListTile(
      leading: GestureDetector(
        onTap: () {
          _onWantsPostCreatorProfile(context);
        },
        child: OBUserAvatar(
          size: OBUserAvatarSize.medium,
          avatarUrl: _post.getCreatorAvatar(),
        ),
      ),
      trailing: IconButton(
          icon: Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
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
          _onWantsPostCreatorProfile(context);
        },
        child: Text(
          _post.getCreatorUsername(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: Text(
        _post.getRelativeCreated(),
        style: TextStyle(fontSize: 12.0),
      ),
    );
  }

  void _onWantsPostCreatorProfile(BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute<void>(
        builder: (BuildContext context) => OBProfilePage(_post.creator)));
  }
}
