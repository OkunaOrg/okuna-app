import 'package:Openbook/models/badge.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/models/user_profile_badge.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBUserBadge extends StatelessWidget {
  final UserProfileBadge badge;
  final OBUserBadgeSize size;
  static double badgeSizeLarge = 45;
  static double badgeSizeMedium = 25;
  static double badgeSizeSmall = 15;
  static double badgeSizeExtraSmall = 10;

  static double iconSizeLarge = 28;
  static double iconSizeMedium = 18;
  static double iconSizeSmall = 12;
  static double iconSizeExtraSmall = 8;


  const OBUserBadge({Key key, this.badge, this.size = OBUserBadgeSize.medium}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    if (badge == null) return const SizedBox();
    double badgeSize = _getUserBadgeSize(size);

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {

          switch(badge.getKeyword()) {
            case BadgeKeyword.verified:
              return _getVerifiedBadge(badge, snapshot, themeValueParserService); break;
            case BadgeKeyword.founder:
              return _getFounderBadge(badge, snapshot, themeValueParserService); break;
            case BadgeKeyword.golden_founder:
              return _getGoldenFounderBadge(badge, snapshot, themeValueParserService); break;
            case BadgeKeyword.diamond_founder:
              return _getDiamondFounderBadge(badge, snapshot, themeValueParserService); break;
            case BadgeKeyword.super_founder:
              return _getSuperFounderBadge(badge, snapshot, themeValueParserService); break;
            case BadgeKeyword.none:
              return const SizedBox(); break;
          }
        });
  }

  Widget _getVerifiedBadge(UserProfileBadge badge, AsyncSnapshot<OBTheme> snapshot, ThemeValueParserService themeValueParserService) {
    var theme = snapshot.data;
    var secondaryTextColor =
    themeValueParserService.parseGradient(theme.secondaryTextColor);
    double badgeSize = _getUserBadgeSize(size);

    return Container(
      margin: EdgeInsets.only(left: 4.0, right: 4.0),
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.2, 0.6, 0.8],
            colors: [
              Colors.blue[300],
              Colors.blueAccent[200],
              Colors.blue[800],
            ],
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Center(
        child: OBIcon(OBIcons.check, customSize: _getUserBadgeIconSize(size), color: Colors.white),
      ),
    );
  }

  Widget _getFounderBadge(UserProfileBadge badge, AsyncSnapshot<OBTheme> snapshot, ThemeValueParserService themeValueParserService) {
    var theme = snapshot.data;
    var primaryAccentColor =
    themeValueParserService.parseGradient(theme.primaryAccentColor);
    double badgeSize = _getUserBadgeSize(size);

    return Container(
      margin: EdgeInsets.only(left: 4.0, right: 4.0),
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.2, 0.5, 0.7, 0.9],
            colors: [
              Colors.green[300],
              Colors.lightGreenAccent[200],
              Colors.yellow[700],
              Colors.orange[400],
              Colors.orangeAccent[400],
            ],
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Center(
        child: OBIcon(OBIcons.check, customSize: _getUserBadgeIconSize(size), color: Colors.white),
      ),
    );
  }

  Widget _getGoldenFounderBadge(UserProfileBadge badge, AsyncSnapshot<OBTheme> snapshot, ThemeValueParserService themeValueParserService) {
    var theme = snapshot.data;
    var primaryAccentColor =
    themeValueParserService.parseGradient(theme.primaryAccentColor);
    double badgeSize = _getUserBadgeSize(size);

    return Container(
      margin: EdgeInsets.only(left: 4.0, right: 4.0),
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.3, 0.8],
            colors: [
              Colors.yellowAccent[400],
              Colors.yellow[700],
              Colors.yellow[800],
            ],
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Center(
        child: OBIcon(OBIcons.check, customSize: _getUserBadgeIconSize(size), color: Colors.white),
      ),
    );
  }

  Widget _getDiamondFounderBadge(UserProfileBadge badge, AsyncSnapshot<OBTheme> snapshot, ThemeValueParserService themeValueParserService) {
    var theme = snapshot.data;
    var primaryAccentColor =
    themeValueParserService.parseGradient(theme.primaryAccentColor);
    double badgeSize = _getUserBadgeSize(size);

    return Container(
      margin: EdgeInsets.only(left: 4.0, right: 4.0),
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.2, 0.6, 0.8],
            colors: [
              Colors.red[100],
              Colors.redAccent[100],
              Colors.red[300],
            ],
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Center(
        child: OBIcon(OBIcons.check, customSize: _getUserBadgeIconSize(size), color: Colors.white),
      ),
    );
  }

  Widget _getSuperFounderBadge(UserProfileBadge badge, AsyncSnapshot<OBTheme> snapshot, ThemeValueParserService themeValueParserService) {
    var theme = snapshot.data;
    var primaryAccentColor =
    themeValueParserService.parseGradient(theme.primaryAccentColor);
    double badgeSize = _getUserBadgeSize(size);

    return Container(
      margin: EdgeInsets.only(left: 4.0, right: 4.0),
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.5, 0.8],
            colors: [
              Colors.deepPurple[200],
              Colors.deepPurple[100],
              Colors.blue[200],
            ],
          ),
          borderRadius: BorderRadius.circular(50)
      ),
      child: Center(
        child: OBIcon(OBIcons.check, customSize: _getUserBadgeIconSize(size), color: Colors.white),
      ),
    );
  }

  double _getUserBadgeIconSize(OBUserBadgeSize size) {
    double iconSize;

    switch (size) {
      case OBUserBadgeSize.large:
        iconSize = iconSizeLarge;
        break;
      case OBUserBadgeSize.medium:
        iconSize = iconSizeMedium;
        break;
      case OBUserBadgeSize.small:
        iconSize = iconSizeSmall;
        break;
      case OBUserBadgeSize.extraSmall:
        iconSize = iconSizeExtraSmall;
        break;
    }

    return iconSize;
  }

  double _getUserBadgeSize(OBUserBadgeSize size) {
    double badgeSize;

    switch (size) {
      case OBUserBadgeSize.large:
        badgeSize = badgeSizeLarge;
        break;
      case OBUserBadgeSize.medium:
        badgeSize = badgeSizeMedium;
        break;
      case OBUserBadgeSize.small:
        badgeSize = badgeSizeSmall;
        break;
      case OBUserBadgeSize.extraSmall:
        badgeSize = badgeSizeExtraSmall;
        break;
    }

    return badgeSize;
  }
}

enum OBUserBadgeSize { small, medium, large, extraSmall }
