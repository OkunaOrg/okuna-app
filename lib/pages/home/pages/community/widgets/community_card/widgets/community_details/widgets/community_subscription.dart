import 'package:Okuna/models/community.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../provider.dart';

class OBCommunitySubscription extends StatelessWidget {
  final Community community;

  const OBCommunitySubscription(this.community);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService = OpenbookProvider.of(context).localizationService;

    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community community = snapshot.data;
        if (community.isSubscribed == null || !community.isSubscribed)
          return const SizedBox();

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OBIcon(
              OBIcons.notifications,
              themeColor: OBIconThemeColor.primaryAccent,
              size: OBIconSize.small,
            ),
            const SizedBox(
              width: 10,
            ),
            OBText(
              localizationService.community__details_subscribed,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        );
      },
    );
  }
}
