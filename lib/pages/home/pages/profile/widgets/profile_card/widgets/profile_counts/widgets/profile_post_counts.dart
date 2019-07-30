import 'package:Openbook/libs/pretty_count.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/localization.dart';
import 'package:flutter/material.dart';

class OBProfilePostsCount extends StatelessWidget {
  final User user;

  OBProfilePostsCount(this.user);

  @override
  Widget build(BuildContext context) {
    int postsCount = user.postsCount;

    if (postsCount == null || postsCount == 0) return const SizedBox();

    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    LocalizationService _localizationService = openbookProvider.localizationService;
    String count = getPrettyCount(postsCount, _localizationService);

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
                          color: themeValueParserService.parseColor(theme.primaryTextColor))),
                  TextSpan(
                      text: postsCount == 1 ? _localizationService.post__profile_counts_post : _localizationService.post__profile_counts_posts,
                      style: TextStyle(
                          color: themeValueParserService.parseColor(theme.secondaryTextColor)))
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
