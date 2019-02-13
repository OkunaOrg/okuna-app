import 'package:Openbook/models/community.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:Openbook/widgets/progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCommunityNavBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Community community;
  final bool refreshInProgress;
  final VoidCallback onWantsRefresh;

  const OBCommunityNavBar(this.community,
      {@required this.refreshInProgress, @required this.onWantsRefresh});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: community.updateSubject,
        builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
          var community = snapshot.data;

          if (community == null) return const SizedBox();

          String communityColor = community.color;
          ThemeValueParserService themeValueParserService =
              OpenbookProvider.of(context).themeValueParserService;
          Color color = themeValueParserService.parseColor(communityColor);
          bool isDarkColor = themeValueParserService.isDarkColor(color);
          Color actionsColor = isDarkColor ? Colors.white : Colors.black;

          return CupertinoNavigationBar(
              border: null,
              actionsForegroundColor: actionsColor,
              middle: Text(
                community.name,
                style: TextStyle(color: actionsColor),
              ),
              transitionBetweenRoutes: false,
              backgroundColor: color,
              trailing: refreshInProgress
                  ? OBProgressIndicator(color: actionsColor)
                  : GestureDetector(
                      onTap: onWantsRefresh,
                      child: OBIcon(
                        OBIcons.refresh,
                        color: actionsColor,
                      ),
                    ));
        });
  }

  bool get fullObstruction {
    return true;
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }
}
