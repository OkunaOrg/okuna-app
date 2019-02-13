import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/users_list.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityModerators extends StatelessWidget {
  final Community community;

  OBCommunityModerators(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;
        UsersList communityModerators = community?.moderators;

        if (communityModerators == null)
          return const SizedBox(
            height: 10.0,
          );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[OBText('Mods')],
        );
      },
    );
  }
}
