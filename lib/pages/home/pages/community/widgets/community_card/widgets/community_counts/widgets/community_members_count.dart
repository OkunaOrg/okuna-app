import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/community.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';

class OBCommunityMembersCount extends StatelessWidget {
  final Community community;

  OBCommunityMembersCount(this.community);

  @override
  Widget build(BuildContext context) {
    int membersCount = community.membersCount;

    if (membersCount == null ||
        membersCount == 0) return const SizedBox();

    String count = getPrettyCount(membersCount);

    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

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
                          color: themeValueParserService
                              .parseColor(theme.primaryTextColor))),
                  TextSpan(
                      text: membersCount == 1 ? ' Follower' : ' Followers',
                      style: TextStyle(
                          color: themeValueParserService
                              .parseColor(theme.secondaryTextColor)))
                ])),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          );
        });
  }
}
