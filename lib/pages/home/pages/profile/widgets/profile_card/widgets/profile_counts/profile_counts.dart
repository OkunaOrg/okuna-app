import 'package:Okuna/models/user.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/widgets/profile_followers_count.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/widgets/profile_following_count.dart';
import 'package:Okuna/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/widgets/profile_post_counts.dart';
import 'package:flutter/material.dart';

class OBProfileCounts extends StatelessWidget {
  final User user;

  const OBProfileCounts(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        return Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
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
      },
    );
  }
}
