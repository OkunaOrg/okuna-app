import 'package:Openbook/models/user.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/widgets/profile_followers_count.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/widgets/profile_following_count.dart';
import 'package:Openbook/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/widgets/profile_post_counts.dart';
import 'package:flutter/material.dart';

class OBProfileCounts extends StatelessWidget {
  User user;

  OBProfileCounts(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.0, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Wrap(
                runSpacing: 10.0,
                children: <Widget>[
                  OBProfileFollowersCount(user),
                  OBProfilePostsCount(user),
                  OBProfileFollowingCount(user),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
