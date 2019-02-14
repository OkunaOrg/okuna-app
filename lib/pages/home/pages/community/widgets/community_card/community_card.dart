import 'package:Openbook/models/community.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_actions/community_actions.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_categories.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_description.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_details/community_details.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_name.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_title.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/avatars/letter_avatar.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:flutter/material.dart';

class OBCommunityCard extends StatelessWidget {
  final Community community;

  OBCommunityCard(this.community);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 30.0, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              StreamBuilder(
                  stream: community.updateSubject,
                  builder: (BuildContext context,
                      AsyncSnapshot<Community> snapshot) {
                    Community community = snapshot.data;

                    if (community == null) return SizedBox();

                    bool communityHasAvatar = community.hasAvatar();

                    Widget avatar;

                    if (communityHasAvatar) {
                      avatar = OBAvatar(
                        avatarUrl: community?.avatar,
                        size: OBAvatarSize.large,
                      );
                    } else {
                      String communityHexColor = community.color;
                      ThemeValueParserService themeValueParserService =
                          OpenbookProvider.of(context).themeValueParserService;
                      Color communityColor =
                          themeValueParserService.parseColor(communityHexColor);
                      Color textColor =
                          themeValueParserService.isDarkColor(communityColor)
                              ? Colors.white
                              : Colors.black;
                      avatar = OBLetterAvatar(
                          letter: community.name[0],
                          color: communityColor,
                          size: OBAvatarSize.large,
                          labelColor: textColor);
                    }

                    return avatar;
                  }),
              Expanded(child: OBCommunityActions(community)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBCommunityTitle(community),
              OBCommunityName(community),
              OBCommunityDescription(community),
              OBCommunityDetails(community),
              OBCommunityCategories(community),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
