import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_bio.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_location.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_name.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_username.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class OBProfileCard extends StatelessWidget {
  final User user;

  OBProfileCard(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Positioned(
          top: -((OBUserAvatar.AVATAR_SIZE_LARGE / 2) * 0.7),
          left: 30,
          child: OBUserAvatar(
            avatarUrl: user.getProfileAvatar(),
            size: OBUserAvatarSize.large,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: OBUserAvatar.AVATAR_SIZE_LARGE,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          OBProfileName(user),
                          OBProfileUsername(user)
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Column(
                children: <Widget>[OBProfileBio(user), OBProfileLocation(user)],
              ),
            )
          ],
        ),
      ],
    );
  }
}
