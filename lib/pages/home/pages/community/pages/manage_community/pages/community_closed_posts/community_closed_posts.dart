import 'package:Okuna/models/community.dart';
import 'package:Okuna/pages/home/pages/community/pages/manage_community/pages/community_closed_posts/widgets/closed_posts.dart';
import 'package:Okuna/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Okuna/widgets/page_scaffold.dart';
import 'package:Okuna/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCommunityClosedPostsPage extends StatelessWidget {
  final Community community;

  OBCommunityClosedPostsPage(this.community);

  @override
  Widget build(BuildContext context) {

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Closed posts',
      ),
      child: OBPrimaryColorContainer(
        child: OBCommunityClosedPosts(
            community: this.community
        )
      ),
    );
  }
}
