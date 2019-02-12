import 'package:Openbook/models/community.dart';
import 'package:Openbook/pages/home/pages/community/widgets/community_card/widgets/community_counts/widgets/community_members_count.dart';
import 'package:flutter/material.dart';

class OBCommunityCounts extends StatelessWidget {
  final Community community;

  const OBCommunityCounts(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;
        if (community == null) return const SizedBox();

        return Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  child: Wrap(
                    runSpacing: 10.0,
                    children: <Widget>[
                      OBCommunityMembersCount(community),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
