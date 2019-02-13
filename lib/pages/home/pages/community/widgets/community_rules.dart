import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityRules extends StatelessWidget {
  final Community community;

  OBCommunityRules(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;
        String communityRules = community?.rules;

        if (communityRules == null) return const SizedBox();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[OBText(community.rules)],
        );
      },
    );
  }
}
