import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBNavigationBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Widget leading;
  final String title;
  final Widget trailing;
  final String previousPageTitle;

  OBNavigationBar({
    this.leading,
    this.previousPageTitle,
    this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;

    return StreamBuilder(
      stream: themeService.themeChange,
      initialData: themeService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        var theme = snapshot.data;

        return CupertinoNavigationBar(
          border: null,
          actionsForegroundColor: theme != null
              ? Pigment.fromString(theme.primaryTextColor)
              : Colors.black,
          middle: title != null
              ? Text(
                  title,
                  style: TextStyle(
                      color: Pigment.fromString(theme.primaryTextColor)),
                )
              : SizedBox(),
          transitionBetweenRoutes: false,
          backgroundColor: Colors.white,
          trailing: trailing,
          leading: leading,
        );
      },
    );
  }

  /// True if the navigation bar's background color has no transparency.
  @override
  bool get fullObstruction => true;

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }
}
