import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_actions/community_actions.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_categories.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_description.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_details/community_details.dart';
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
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 30.0, right: 20),
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
                  OBCommunityDetails(community),
                  OBCommunityCategories(community),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
