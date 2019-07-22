import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:flutter/material.dart';

class OBProfileFollowersCount extends StatelessWidget {
  final User user;

  OBProfileFollowersCount(this.user);

  @override
  Widget build(BuildContext context) {
    int followersCount = user.followersCount;

    if (followersCount == null ||
        followersCount == 0 ||
        user.getProfileFollowersCountVisible() == false)
      return const SizedBox();

    String count = getPrettyCount(followersCount);

    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    var userService = openbookProvider.userService;
    var navigationService = openbookProvider.navigationService;
    LocalizationService _localizationService = openbookProvider.localizationService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return GestureDetector(
            onTap: () {
              if (userService.isLoggedInUser(user)) {
                navigationService.navigateToFollowersPage(context: context);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: count,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeValueParserService
                                .parseColor(theme.primaryTextColor))),
                    TextSpan(
                        text: followersCount == 1 ? _localizationService.post__profile_counts_follower : _localizationService.post__profile_counts_followers,
                        style: TextStyle(
                            color: themeValueParserService
                                .parseColor(theme.secondaryTextColor)))
                  ])),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          );
        });
  }
}
