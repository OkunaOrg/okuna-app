import 'package:Okuna/libs/pretty_count.dart';
import 'package:Okuna/libs/str_utils.dart';
import 'package:Okuna/models/theme.dart';
import 'package:Okuna/models/community.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:flutter/material.dart';

class OBCommunityPostsCount extends StatelessWidget {
  final Community community;

  OBCommunityPostsCount(this.community);

  @override
  Widget build(BuildContext context) {
    int postsCount = community.postsCount;
    LocalizationService localizationService = OpenbookProvider.of(context).localizationService;

    if (postsCount == null || postsCount == 0) return const SizedBox();

    String count = getPrettyCount(postsCount, localizationService);

    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    var userService = openbookProvider.userService;
    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          bool isPublicCommunity = community.isPublic();
          bool isLoggedInUserMember = community.isMember(userService.getLoggedInUser());

          if (!isPublicCommunity && !isLoggedInUserMember) return SizedBox();

          return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: count,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeValueParserService
                                .parseColor(theme.primaryTextColor))),
                    TextSpan(text: ' '),
                    TextSpan(
                        text:
                            postsCount == 1 ?
                            toCapital(localizationService.community__post_singular) :
                            toCapital(localizationService.community__post_plural),
                        style: TextStyle(
                            fontSize: 16,
                            color: themeValueParserService
                                .parseColor(theme.secondaryTextColor)))
                  ])),
                ),
              ],
            );
        });
  }
}
