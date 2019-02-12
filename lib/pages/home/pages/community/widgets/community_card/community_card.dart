import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_actions/community_actions.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';

class OBCommunityCard extends StatelessWidget {
  final Community community;

  OBCommunityCard(this.community);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

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
                    height: (OBAvatar.AVATAR_SIZE_LARGE * 0.4),
                    width: OBAvatar.AVATAR_SIZE_LARGE,
                  ),
                  Expanded(child: OBCommunityActions(community)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
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
          top: -((OBAvatar.AVATAR_SIZE_LARGE / 2) * 0.7) - 10,
          left: 30,
          child: StreamBuilder(
              stream: community.updateSubject,
              builder:
                  (BuildContext context, AsyncSnapshot<Community> snapshot) {
                Community community = snapshot.data;

                return OBAvatar(
                  borderWidth: 3,
                  avatarUrl: community?.avatar,
                  size: OBAvatarSize.large,
                );
              }),
        ),
      ],
    );
  }
}
