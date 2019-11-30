import 'package:Okuna/libs/pretty_count.dart';
import 'package:Okuna/models/theme.dart';
import 'package:Okuna/models/user.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/services/localization.dart';
import 'package:flutter/material.dart';

class OBPostsCount extends StatelessWidget {
  final int postsCount;
  final bool showZero;

  OBPostsCount(this.postsCount, {this.showZero = false});

  @override
  Widget build(BuildContext context) {
    if (postsCount == null || (postsCount == 0 && !showZero)) return const SizedBox();

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
              )
            ],
          );
        });
  }
}
