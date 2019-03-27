import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityRules extends StatelessWidget {
  final Community community;

  OBCommunityRules(this.community);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;

        String communityRules = community?.rules;
        String communityColor = community?.color;

        if (communityRules == null || communityRules.isEmpty || communityColor == null)
          return const SizedBox();


        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    OBText(
                      'Rules',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OBActionableSmartText(text: community.rules)
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
