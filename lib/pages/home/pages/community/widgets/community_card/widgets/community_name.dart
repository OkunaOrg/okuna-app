import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBCommunityName extends StatelessWidget {
  final Community user;

  OBCommunityName(this.user);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;
        String communityName = community?.name;

        if (communityName == null)
          return const SizedBox(
            height: 10.0,
          );

        return OBSecondaryText(
          communityName,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
        );
      },
    );
  }
}
