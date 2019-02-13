import 'package:Openbook/models/community.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/avatars/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/flutter_advanced_networkimage.dart';
import 'package:Openbook/libs/pretty_count.dart';
import 'package:tinycolor/tinycolor.dart';

class OBCommunityTile extends StatelessWidget {
  final Community community;
  final OnCommunityTilePressed onCommunityTilePressed;
  final Widget trailing;

  OBCommunityTile(this.community, {this.onCommunityTilePressed, this.trailing});

  @override
  Widget build(BuildContext context) {
    String communityColor = community.color;
    ThemeValueParserService themeValueParserService =
        OpenbookProvider.of(context).themeValueParserService;
    Color color = themeValueParserService.parseColor(communityColor);
    Color textColor;

    BoxDecoration containerDecoration;
    BorderRadius containerBorderRadius = BorderRadius.circular(10);
    bool isCommunityColorDark = themeValueParserService.isDarkColor(color);

    if (community.hasCover()) {
      textColor = Colors.white;
      containerDecoration = BoxDecoration(
          borderRadius: containerBorderRadius,
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.darken),
              image:
                  AdvancedNetworkImage(community.cover, useDiskCache: true)));
    } else {
      textColor = isCommunityColorDark ? Colors.white : Colors.black;
      bool communityColorIsNearWhite = color.computeLuminance() > 0.9;

      containerDecoration = BoxDecoration(
        color: communityColorIsNearWhite
            ? TinyColor(color).darken(2).color
            : color,
        borderRadius: containerBorderRadius,
      );
    }

    Widget communityAvatar;
    if (community.hasAvatar()) {
      communityAvatar = OBAvatar(
        avatarUrl: community.avatar,
        size: OBAvatarSize.medium,
      );
    } else {
      communityAvatar = Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
            color: isCommunityColorDark
                ? Color.fromARGB(20, 255, 255, 255)
                : Color.fromARGB(10, 0, 0, 0),
            borderRadius: containerBorderRadius),
        child: Center(
          child: Text(
            community.name[0].toUpperCase(),
            style: TextStyle(
                color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
      );
    }

    String userAdjective = community.userAdjective ?? 'Member';
    String usersAdjective = community.usersAdjective ?? 'Members';
    String membersPrettyCount = getPrettyCount(community.membersCount);
    String finalAdjective =
        community.membersCount == 1 ? userAdjective : usersAdjective;

    return GestureDetector(
      onTap: () {
        onCommunityTilePressed(community);
      },
      child: Container(
        height: 80,
        decoration: containerDecoration,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: communityAvatar,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('c/' + community.name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis),
                  Text(
                    community.title,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$membersPrettyCount $finalAdjective',
                    style: TextStyle(color: textColor, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}

typedef void OnCommunityTilePressed(Community community);
