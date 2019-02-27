import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A navigation bar that uses the current theme colours
class OBThemedNavigationBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Widget leading;
  final String title;
  final Widget trailing;
  final String previousPageTitle;

  OBThemedNavigationBar({
    this.leading,
    this.previousPageTitle,
    this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    return StreamBuilder(
      stream: themeService.themeChange,
      initialData: themeService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        var theme = snapshot.data;

        Color actionsForegroundColor = themeValueParserService
            .parseGradient(theme.primaryAccentColor)
            .colors[1];


        return CupertinoNavigationBar(
          border: null,
          actionsForegroundColor:
          actionsForegroundColor != null ? actionsForegroundColor : Colors.black,
          middle: title != null
              ? OBText(
                  title,
                )
              : const SizedBox(),
          transitionBetweenRoutes: false,
          backgroundColor:
              themeValueParserService.parseColor(theme.primaryColor),
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
