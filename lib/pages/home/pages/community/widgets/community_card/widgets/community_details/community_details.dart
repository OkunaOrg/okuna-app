import 'package:Openbook/models/community.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_details/widgets/community_members_count.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_details/widgets/community_type.dart';
import 'package:flutter/material.dart';

class OBCommunityDetails extends StatelessWidget {
  final Community community;

  const OBCommunityDetails(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community community = snapshot.data;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: SizedBox(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: <Widget>[
                    OBCommunityType(community),
                    OBCommunityMembersCount(community)
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
