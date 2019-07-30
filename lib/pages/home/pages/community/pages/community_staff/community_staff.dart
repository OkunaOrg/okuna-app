import 'package:Openbook/models/community.dart';
import 'package:Openbook/pages/home/pages/community/pages/community_staff/widgets/community_administrators.dart';
import 'package:Openbook/pages/home/pages/community/pages/community_staff/widgets/community_moderators.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:flutter/material.dart';

class OBCommunityStaffPage extends StatelessWidget {
  final Community community;

  const OBCommunityStaffPage({Key key, @required this.community})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Community staff',
      ),
      child: OBPrimaryColorContainer(
        child: StreamBuilder(
          stream: community.updateSubject,
          initialData: community,
          builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  OBCommunityAdministrators(community),
                  OBCommunityModerators(community),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
