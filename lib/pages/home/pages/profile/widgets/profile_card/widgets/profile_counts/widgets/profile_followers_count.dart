import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBProfileFollowersCount extends StatelessWidget {
  final User user;

  OBProfileFollowersCount(this.user);

  @override
  Widget build(BuildContext context) {
    int followersCount = user.followersCount;

    if (followersCount == null ||
        followersCount == 0 ||
        user.getProfileFollowersCountVisible() == false) return SizedBox();

    String count = getPrettyCount(followersCount);

    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return Row(
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
                          color: Pigment.fromString(theme.primaryTextColor))),
                  TextSpan(
                      text: followersCount == 1 ? ' Follower' : ' Followers',
                      style: TextStyle(
                          color: Pigment.fromString(theme.secondaryTextColor)))
                ])),
              ),
              SizedBox(
                width: 10,
              )
            ],
          );
        });
  }
}
