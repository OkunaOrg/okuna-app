import 'package:Openbook/models/community.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityRulesPage extends StatelessWidget {
  final Community community;

  const OBCommunityRulesPage({Key key, @required this.community})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Community rules',
      ),
      child: OBPrimaryColorContainer(
        child: StreamBuilder(
          stream: community.updateSubject,
          initialData: community,
          builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
            var community = snapshot.data;

            String communityRules = community?.rules;
            String communityColor = community?.color;

            if (communityRules == null ||
                communityRules.isEmpty ||
                communityColor == null) return const SizedBox();

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
        ),
      ),
    );
  }
}
