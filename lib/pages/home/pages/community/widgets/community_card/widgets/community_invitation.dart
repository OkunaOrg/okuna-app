import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/alert.dart';
import 'package:Openbook/widgets/buttons/actions/confirm_connection_button.dart';
import 'package:Openbook/widgets/buttons/actions/deny_connection_button.dart';
import 'package:Openbook/widgets/buttons/actions/join_community_button.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityInvitation extends StatelessWidget {
  final Community community;

  OBCommunityInvitation(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community community = snapshot.data;
        bool isInvited = community?.isInvited;

        if (isInvited == null) return const SizedBox();

        String communityName = community.name;

        return Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            OBAlert(
              child: Column(
                children: <Widget>[
                  OBText(
                    'You have been invited to join the community.',
                    maxLines: 4,
                    size: OBTextSize.medium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      OBJoinCommunityButton(community),
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
