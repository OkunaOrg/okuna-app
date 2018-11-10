import 'package:flutter/material.dart';

enum OBIconSize { small, medium, large }

class OBIcon extends StatelessWidget {
  final OBIconData iconData;
  final OBIconSize size;
  final double customSize;

  static const double LARGE_SIZE = 30.0;
  static const double MEDIUM_SIZE = 20.0;
  static const double SMALL_SIZE = 10.0;

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
      'assets/images/icons/$iconName-icon.png',
      height: iconSize,
    );
  }
}

class OBIcons {
  static const success = OBIconData('success');
  static const error = OBIconData('error');
  static const warning = OBIconData('warning');
  static const info = OBIconData('info');
  static const profile = OBIconData('profile');
  static const connections = OBIconData('connections');
  static const settings = OBIconData('settings');
  static const help = OBIconData('help');
  static const customize = OBIconData('customize');
  static const logout = OBIconData('logout');
  static const home = OBIconData('home');
  static const search = OBIconData('search');
  static const createPost = OBIconData('create-post');
  static const notifications = OBIconData('notifications');
  static const communities = OBIconData('communities');
  static const chat = OBIconData('chat');
  static const media = OBIconData('media');
  static const camera = OBIconData('camera');
  static const gif = OBIconData('gif');
  static const audience = OBIconData('audience');
  static const burner = OBIconData('burner');
}

@immutable
class OBIconData {
  final String filename;

  const OBIconData(this.filename);
}
