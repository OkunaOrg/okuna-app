import 'package:Openbook/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class OBLoggedInUserAvatarDrawerOpener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        OBLoggedInUserAvatar(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          size: OBUserAvatarSize.medium,
        )
      ],
    );
  }
}
