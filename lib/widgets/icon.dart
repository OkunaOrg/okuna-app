import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';

enum OBIconSize { small, medium, large, extraLarge }

class OBIcon extends StatelessWidget {
  final OBIconData iconData;
  final OBIconSize size;
  final double customSize;
  final Color color;
  final OBIconThemeColor themeColor;

  static const double EXTRA_LARGE = 45.0;
  static const double LARGE_SIZE = 30.0;
  static const double MEDIUM_SIZE = 25.0;
  static const double SMALL_SIZE = 15.0;

  const OBIcon(this.iconData,
      {this.size, this.customSize, this.color, this.themeColor})
      : assert(!(color != null && themeColor != null));

  @override
  Widget build(BuildContext context) {
    double iconSize;

    if (this.customSize != null) {
      iconSize = this.customSize;
    } else {
      var finalSize = size ?? OBIconSize.medium;
      switch (finalSize) {
        case OBIconSize.extraLarge:
          iconSize = EXTRA_LARGE;
          break;
        case OBIconSize.large:
          iconSize = LARGE_SIZE;
          break;
        case OBIconSize.medium:
          iconSize = MEDIUM_SIZE;
          break;
        case OBIconSize.small:
          iconSize = SMALL_SIZE;
          break;
        default:
          throw 'Unsupported OBIconSize';
      }
    }

    var themeService = OpenbookProvider.of(context).themeService;
    var themeValueParser = OpenbookProvider.of(context).themeValueParserService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          Widget icon;

          if (iconData.nativeIcon != null) {
            Color iconColor;
            Gradient iconGradient;

            if (color != null) {
              iconColor = color;
            } else {
              switch (themeColor) {
                case OBIconThemeColor.primary:
                  iconColor = themeValueParser.parseColor(theme.primaryColor);
                  break;
                case OBIconThemeColor.primaryText:
                  iconColor =
                      themeValueParser.parseColor(theme.primaryTextColor);
                  break;
                case OBIconThemeColor.secondaryText:
                  iconColor =
                      themeValueParser.parseColor(theme.secondaryTextColor);
                  break;
                case OBIconThemeColor.primaryAccent:
                  iconGradient =
                      themeValueParser.parseGradient(theme.primaryAccentColor);
                  break;
                case OBIconThemeColor.danger:
                  iconGradient =
                      themeValueParser.parseGradient(theme.dangerColor);
                  break;
                default:
                  iconColor =
                      themeValueParser.parseColor(theme.primaryTextColor);
              }
            }

            if (iconColor != null) {
              icon = Icon(
                iconData.nativeIcon,
                size: iconSize,
                color: iconColor,
              );
            } else {
              icon = ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return iconGradient.createShader(bounds);
                },
                child: Icon(
                  iconData.nativeIcon,
                  color: Colors.white,
                  size: iconSize,
                ),
              );
            }
          } else {
            String iconName = iconData.filename;
            icon =
                Image.asset('assets/images/icons/$iconName', height: iconSize);
          }

          return icon;
        });
  }
}

class OBIcons {
  static const home = OBIconData(nativeIcon: Icons.home);
  static const pause = OBIconData(nativeIcon: Icons.pause);
  static const play_arrow = OBIconData(nativeIcon: Icons.play_arrow);
  static const search = OBIconData(nativeIcon: Icons.search);
  static const notifications = OBIconData(nativeIcon: Icons.notifications);
  static const menu = OBIconData(nativeIcon: Icons.menu);
  static const communities = OBIconData(nativeIcon: Icons.bubble_chart);
  static const settings = OBIconData(nativeIcon: Icons.settings);
  static const lists = OBIconData(nativeIcon: Icons.library_books);
  static const addToList = OBIconData(nativeIcon: Icons.queue);
  static const removeFromList = OBIconData(nativeIcon: Icons.delete);
  static const customize = OBIconData(nativeIcon: Icons.format_paint);
  static const logout = OBIconData(nativeIcon: Icons.exit_to_app);
  static const help = OBIconData(nativeIcon: Icons.help);
  static const refresh = OBIconData(nativeIcon: Icons.refresh);
  static const connections = OBIconData(nativeIcon: Icons.people);
  static const createPost = OBIconData(nativeIcon: Icons.add);
  static const add = OBIconData(nativeIcon: Icons.add);
  static const moreVertical = OBIconData(nativeIcon: Icons.more_vert);
  static const moreHorizontal = OBIconData(nativeIcon: Icons.more_horiz);
  static const react = OBIconData(nativeIcon: Icons.sentiment_very_satisfied);
  static const comment = OBIconData(nativeIcon: Icons.chat_bubble_outline);
  static const close = OBIconData(nativeIcon: Icons.close);
  static const sad = OBIconData(nativeIcon: Icons.sentiment_dissatisfied);
  static const location = OBIconData(nativeIcon: Icons.location_on);
  static const link = OBIconData(nativeIcon: Icons.link);
  static const email = OBIconData(nativeIcon: Icons.email);
  static const lock = OBIconData(nativeIcon: Icons.lock);
  static const bio = OBIconData(nativeIcon: Icons.bookmark);
  static const name = OBIconData(nativeIcon: Icons.person);
  static const followers = OBIconData(nativeIcon: Icons.supervisor_account);
  static const cake = OBIconData(nativeIcon: Icons.cake);
  static const remove = OBIconData(nativeIcon: Icons.remove_circle_outline);
  static const checkCircle =
      OBIconData(nativeIcon: Icons.radio_button_unchecked);
  static const checkCircleSelected = OBIconData(nativeIcon: Icons.check_circle);
  static const check = OBIconData(nativeIcon: Icons.check);
  static const circles = OBIconData(nativeIcon: Icons.group_work);
  static const follow = OBIconData(nativeIcon: Icons.notifications);
  static const unfollow = OBIconData(nativeIcon: Icons.notifications_off);
  static const connect = OBIconData(nativeIcon: Icons.group_add);
  static const disconnect = OBIconData(nativeIcon: Icons.remove_circle_outline);
  static const deletePost = OBIconData(nativeIcon: Icons.delete);
  static const reportPost = OBIconData(nativeIcon: Icons.report);
  static const filter = OBIconData(nativeIcon: Icons.tune);
  static const gallery = OBIconData(nativeIcon: Icons.apps);
  static const camera = OBIconData(nativeIcon: Icons.camera_alt);
  static const privateCommunity = OBIconData(nativeIcon: Icons.lock);
  static const publicCommunity = OBIconData(nativeIcon: Icons.public);
  static const communityDescription = OBIconData(nativeIcon: Icons.book);
  static const communityTitle = OBIconData(nativeIcon: Icons.public);
  static const communityName = OBIconData(nativeIcon: Icons.public);
  static const communityRules = OBIconData(nativeIcon: Icons.straighten);
  static const category = OBIconData(nativeIcon: Icons.category);
  static const communityMember = OBIconData(nativeIcon: Icons.person);
  static const communityMembers = OBIconData(nativeIcon: Icons.people);
  static const color = OBIconData(nativeIcon: Icons.format_paint);
  static const shortText = OBIconData(nativeIcon: Icons.short_text);
  static const communityAdministrators = OBIconData(nativeIcon: Icons.star);
  static const communityModerators = OBIconData(nativeIcon: Icons.gavel);
  static const communityBannedUsers = OBIconData(nativeIcon: Icons.block);
  static const deleteCommunity = OBIconData(nativeIcon: Icons.delete_forever);
  static const seeMore = OBIconData(nativeIcon: Icons.arrow_right);
  static const leaveCommunity = OBIconData(nativeIcon: Icons.exit_to_app);

  static const success = OBIconData(filename: 'success-icon.png');
  static const error = OBIconData(filename: 'error-icon.png');
  static const warning = OBIconData(filename: 'warning-icon.png');
  static const info = OBIconData(filename: 'info-icon.png');
  static const profile = OBIconData(filename: 'profile-icon.png');
  static const chat = OBIconData(filename: 'chat-icon.png');
  static const photo = OBIconData(filename: 'photo-icon.png');
  static const video = OBIconData(filename: 'video-icon.png');
  static const gif = OBIconData(filename: 'gif-icon.png');
  static const audience = OBIconData(filename: 'audience-icon.png');
  static const burner = OBIconData(filename: 'burner-icon.png');
  static const comments = OBIconData(filename: 'comments-icon.png');
  static const like = OBIconData(filename: 'like-icon.png');
  static const thinking = OBIconData(filename: 'thinking.gif');
  static const finish = OBIconData(filename: 'finish-icon.png');
  static const loadingMorePosts =
      OBIconData(filename: 'load-more-posts-icon.gif');
}

@immutable
class OBIconData {
  final String filename;
  final IconData nativeIcon;

  const OBIconData({
    this.nativeIcon,
    this.filename,
  });
}

enum OBIconThemeColor {
  primary,
  primaryText,
  primaryAccent,
  danger,
  success,
  secondaryText
}
