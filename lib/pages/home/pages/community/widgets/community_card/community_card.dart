import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_actions/community_actions.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_description.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_name.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_title.dart';
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
                  StreamBuilder(
                      stream: community.updateSubject,
                      builder: (BuildContext context,
                          AsyncSnapshot<Community> snapshot) {
                        Community community = snapshot.data;

                        return OBAvatar(
                          borderWidth: 3,
                          avatarUrl: community?.avatar,
                          size: OBAvatarSize.large,
                        );
                      }),
                  Expanded(child: OBCommunityActions(community)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OBCommunityTitle(community),
                      OBCommunityName(community),
                      OBCommunityDescription(community),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
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
      ],
    );
  }
}
