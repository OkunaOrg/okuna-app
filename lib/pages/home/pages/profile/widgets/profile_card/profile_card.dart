import 'package:Openbook/models/badge.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/profile_actions.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_bio.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_connected_in.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_connection_request.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/profile_counts.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_details/profile_details.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_in_lists.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_name.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_username.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/user_badge.dart';
import 'package:flutter/material.dart';

class OBProfileCard extends StatelessWidget {
  final User user;

  OBProfileCard(this.user);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    var toastService = openbookProvider.toastService;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 30.0, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    height: (OBAvatar.AVATAR_SIZE_EXTRA_LARGE * 0.2),
                    width: OBAvatar.AVATAR_SIZE_EXTRA_LARGE,
                  ),
                  Expanded(child: OBProfileActions(user)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      toastService.info(
                          message: _getUserBadgeDescription(user),
                          context: context);
                    },
                    child: _buildNameRow(user),
                  ),
                  OBProfileUsername(user),
                  OBProfileBio(user),
                  OBProfileDetails(user),
                  OBProfileCounts(user),
                  OBProfileConnectedIn(user),
                  OBProfileConnectionRequest(user),
                  OBProfileInLists(user)
                ],
              ),
            ],
          ),
        ),
        Positioned(
          child: StreamBuilder(
              stream: themeService.themeChange,
              initialData: themeService.getActiveTheme(),
              builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
                var theme = snapshot.data;

                return Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: themeValueParserService
                          .parseColor(theme.primaryColor),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                );
              }),
          top: -19,
        ),
        Positioned(
          top: -((OBAvatar.AVATAR_SIZE_EXTRA_LARGE / 2)) - 10,
          left: 30,
          child: StreamBuilder(
              stream: user.updateSubject,
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                var user = snapshot.data;

                return OBAvatar(
                  borderWidth: 3,
                  avatarUrl: user?.getProfileAvatar(),
                  size: OBAvatarSize.extraLarge,
                );
              }),
        ),
      ],
    );
  }

  Widget _getUserBadge(User user) {
    Badge badge = user.getProfileBadges()[0];
    return OBUserBadge(badge: badge, size: OBUserBadgeSize.small);
  }

  Widget _buildNameRow(User user) {
    if (user.hasProfileBadges() && user.getProfileBadges().length > 0) {
      return Row(children: <Widget>[OBProfileName(user), _getUserBadge(user)]);
    }
    return OBProfileName(user);
  }

  String _getUserBadgeDescription(User user) {
    Badge badge = user.getProfileBadges()[0];
    return '${user.getProfileName()} is an ${badge.getKeywordDescription()}';
  }
}
