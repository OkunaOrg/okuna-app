import 'package:flutter/material.dart';

enum OBIconSize { small, medium, large }

class OBIcon extends StatelessWidget {
  final OBIconData iconData;
  final OBIconSize size;
  final double customSize;

  static const double LARGE_SIZE = 30.0;
  static const double MEDIUM_SIZE = 20.0;
  static const double SMALL_SIZE = 15.0;

  OBIcon(this.iconData, {this.size, this.customSize});

  @override
  Widget build(BuildContext context) {
    double iconSize;

    if (this.customSize != null) {
      iconSize = this.customSize;
    } else {
      var finalSize = size ?? OBIconSize.medium;
      switch (finalSize) {
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

    String iconName = iconData.filename;
    return Image.asset(
      'assets/images/icons/$iconName',
      height: iconSize,
    );
  }
}

class OBIcons {
  static const success = OBIconData('success-icon.png');
  static const error = OBIconData('error-icon.png');
  static const warning = OBIconData('warning-icon.png');
  static const info = OBIconData('info-icon.png');
  static const profile = OBIconData('profile-icon.png');
  static const connections = OBIconData('connections-icon.png');
  static const settings = OBIconData('settings-icon.png');
  static const help = OBIconData('help-icon.png');
  static const customize = OBIconData('customize-icon.png');
  static const logout = OBIconData('logout-icon.png');
  static const home = OBIconData('home-icon.png');
  static const search = OBIconData('search-icon.png');
  static const createPost = OBIconData('create-post-icon.png');
  static const notifications = OBIconData('notifications-icon.png');
  static const communities = OBIconData('communities-icon.png');
  static const chat = OBIconData('chat-icon.png');
  static const media = OBIconData('media-icon.png');
  static const camera = OBIconData('camera-icon.png');
  static const gif = OBIconData('gif-icon.png');
  static const audience = OBIconData('audience-icon.png');
  static const burner = OBIconData('burner-icon.png');
  static const comment = OBIconData('comment-icon.png');
  static const comments = OBIconData('comments-icon.png');
  static const react = OBIconData('react-icon.png');
  static const like = OBIconData('like-icon.png');
  static const finish = OBIconData('finish-icon.png');
  static const loadingMorePosts = OBIconData('load-more-posts-icon.gif');
}

@immutable
class OBIconData {
  final String filename;

  const OBIconData(this.filename);
}
