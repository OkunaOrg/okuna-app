import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A coloured navigation bar, used in communities.
class OBColoredNavBar extends StatelessWidget implements ObstructingPreferredSizeWidget{
  final Color color;
  final Widget leading;
  final Widget trailing;
  final String title;

  const OBColoredNavBar(
      {Key key,
      @required this.color,
      this.leading,
      this.trailing,
      @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeValueParserService themeValueParserService =
        OpenbookProvider.of(context).themeValueParserService;
    bool isDarkColor = themeValueParserService.isDarkColor(color);
    Color actionsColor = isDarkColor ? Colors.white : Colors.black;

    return CupertinoNavigationBar(
        border: null,
        leading: leading,
        actionsForegroundColor: actionsColor,
        middle: Text(
          title,
          style: TextStyle(color: actionsColor),
        ),
        transitionBetweenRoutes: false,
        backgroundColor: color,
        trailing: trailing);
  }

  @override
  bool get fullObstruction => true;

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }
}
