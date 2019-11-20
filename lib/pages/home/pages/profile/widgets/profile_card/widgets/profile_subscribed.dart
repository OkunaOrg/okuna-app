import 'package:Okuna/models/user.dart';
import 'package:Okuna/services/localization.dart';
import 'package:Okuna/widgets/icon.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../provider.dart';

class OBProfileSubscribed extends StatelessWidget {
  final User user;

  OBProfileSubscribed(this.user);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService = OpenbookProvider.of(context).localizationService;

    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        bool isSubscribed = user?.isSubscribed != null && user.isSubscribed;

        if (isSubscribed == null || !isSubscribed) return const SizedBox();

        return Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
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
                  localizationService.user__profile_subscribed,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ));
      },
    );
  }
}
