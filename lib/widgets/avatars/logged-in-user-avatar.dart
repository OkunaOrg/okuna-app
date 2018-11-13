import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/user-avatar.dart';
import 'package:flutter/material.dart';

/// Like the UserAvatar widget but displays the avatar of
/// the logged in user.
class OBLoggedInUserAvatar extends StatelessWidget {
  final OBUserAvatarSize size;
  final VoidCallback onPressed;

  OBLoggedInUserAvatar({this.size, this.onPressed});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    UserService userService = openbookProvider.userService;

    return StreamBuilder(
      stream: userService.loggedInUserChange,
      initialData: null,
      builder: (context, AsyncSnapshot<User> snapshot) {
        User user = snapshot.data;

        var avatarImage;
        if (user != null) {
          avatarImage = user.profile.avatar;
        }

        return OBUserAvatar(
          avatarUrl: avatarImage,
          size: size,
          onPressed: onPressed,
        );
      },
    );
  }
}
