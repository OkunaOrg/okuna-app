import 'package:Openbook/models/post.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/bottom_sheets/post_actions.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostHeader extends StatelessWidget {
  final Post _post;
  final OnPostDeleted onPostDeleted;

  const OBPostHeader(this._post, {Key key, @required this.onPostDeleted})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var navigationService = openbookProvider.navigationService;
    var bottomSheetService = openbookProvider.bottomSheetService;

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
          icon: const OBIcon(OBIcons.moreVertical),
          onPressed: () {
            bottomSheetService.showPostActions(
                context: context,
                post: _post,
                onPostDeleted: onPostDeleted,
                onPostReported: null);
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
