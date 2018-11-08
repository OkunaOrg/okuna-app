import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/user.dart';
import 'package:Openbook/widgets/avatars/user-avatar.dart';
import 'package:flutter/material.dart';

/// Like the UserAvatar widget but displays the avatar of
/// the logged in user.
class LoggedInUserAvatar extends StatelessWidget {
  final UserAvatarSize size;
  final VoidCallback onPressed;

  LoggedInUserAvatar({this.size, this.onPressed});

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
          avatarImage = NetworkImage(user.profile.avatar);
        }

        return UserAvatar(
          avatarImage: avatarImage,
          size: size,
          onPressed: onPressed,
        );
      },
    );
  }
}
