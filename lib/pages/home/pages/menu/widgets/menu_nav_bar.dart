import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBMenuNavBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Widget leading;
  final Widget middle;
  final Widget trailing;
  final String previousPageTitle;

  OBMenuNavBar({
    this.leading,
    this.previousPageTitle,
    this.middle,
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
          actionsForegroundColor: theme != null
              ? Pigment.fromString(theme.menuAccentColor)
              : Colors.black,
          middle: middle,
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
