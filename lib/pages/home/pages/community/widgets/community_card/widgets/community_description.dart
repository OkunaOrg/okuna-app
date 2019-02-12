import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityDescription extends StatelessWidget {
  final Community community;

  const OBCommunityDescription(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;
        var description = community?.description;

        if (description == null) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: OBText(
                  description,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
