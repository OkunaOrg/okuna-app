import 'package:Openbook/models/community.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:Openbook/widgets/avatars/letter_avatar.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class OBCommunityAvatar extends StatelessWidget {
  final Community community;
  final OBAvatarSize size;
  final VoidCallback onPressed;

  const OBCommunityAvatar(
      {Key key,
      @required this.community,
      this.size = OBAvatarSize.small,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: community.updateSubject,
        builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
          Community community = snapshot.data;

          if (community == null) return SizedBox();

          bool communityHasAvatar = community.hasAvatar();

          Widget avatar;

          if (communityHasAvatar) {
            avatar = OBAvatar(
              avatarUrl: community?.avatar,
              size: size,
              onPressed: onPressed,
            );
          } else {
            String communityHexColor = community.color;

            OpenbookProviderState openbookProviderState =
                OpenbookProvider.of(context);
            ThemeValueParserService themeValueParserService =
                openbookProviderState.themeValueParserService;
            ThemeService themeService = openbookProviderState.themeService;

            OBTheme currentTheme = themeService.getActiveTheme();
            Color currentThemePrimaryColor =
                themeValueParserService.parseColor(currentTheme.primaryColor);
            double currentThemePrimaryColorLuminance =
                currentThemePrimaryColor.computeLuminance();

            Color communityColor =
                themeValueParserService.parseColor(communityHexColor);
            double communityColorLuminance = communityColor.computeLuminance();
            Color textColor =
                themeValueParserService.isDarkColor(communityColor)
                    ? Colors.white
                    : Colors.black;

            if (communityColorLuminance > 0.9 &&
                currentThemePrimaryColorLuminance > 0.9) {
              // Is extremely white and our current theem is also extremely white, darken it
              communityColor = TinyColor(communityColor).darken(5).color;
            } else if (communityColorLuminance < 0.1) {
              // Is extremely dark and our current theme is also extremely dark, lighten it
              communityColor = TinyColor(communityColor).lighten(10).color;
            }

            avatar = OBLetterAvatar(
                letter: community.name[0],
                color: communityColor,
                size: size,
                onPressed: onPressed,
                labelColor: textColor);
          }

          return avatar;
        });
  }
}
