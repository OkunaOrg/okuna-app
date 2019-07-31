import 'package:Openbook/models/community.dart';
import 'package:Openbook/services/localization.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Openbook/widgets/page_scaffold.dart';
import 'package:Openbook/widgets/theming/actionable_smart_text.dart';
import 'package:Openbook/widgets/theming/primary_color_container.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../../../provider.dart';

class OBCommunityRulesPage extends StatelessWidget {
  final Community community;

  const OBCommunityRulesPage({Key key, @required this.community})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService _localizationService = OpenbookProvider.of(context).localizationService;

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.community__rules_title,
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

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        OBIcon(
                          OBIcons.rules,
                          size: OBIconSize.medium,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        OBText(
                          _localizationService.community__rules_text,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OBActionableSmartText(text: community.rules)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
