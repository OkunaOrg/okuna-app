import 'package:Openbook/provider.dart';
import 'package:Openbook/services/theme_value_parser.dart';
import 'package:Openbook/widgets/avatars/avatar.dart';
import 'package:flutter/material.dart';
export 'package:Openbook/widgets/avatars/avatar.dart';

class OBLetterAvatar extends StatelessWidget {
  final OBAvatarSize size;
  final Color color;
  final Color labelColor;
  final String letter;

  static const double fontSizeExtraSmall = 10.0;
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 24.0;
  static const double fontSizeLarge = 40.0;
  static const double fontSizeExtraLarge = 60.0;

  const OBLetterAvatar(
      {Key key,
      this.size = OBAvatarSize.medium,
      @required this.color,
      this.labelColor,
      @required this.letter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeValueParserService themeValueParserService =
        OpenbookProvider.of(context).themeValueParserService;
    double avatarSize = OBAvatar.getAvatarSize(size);
    double fontSize = getAvatarFontSize(size);
    Color finalLabelColor =
        labelColor ?? themeValueParserService.isDarkColor(color)
            ? Colors.white
            : Colors.black;

    return Container(
      height: avatarSize,
      width: avatarSize,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(OBAvatar.avatarBorderRadius)),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: TextStyle(
              color: finalLabelColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize),
        ),
      ),
    );
  }

  double getAvatarFontSize(OBAvatarSize size) {
    double fontSize;

    switch (size) {
      case OBAvatarSize.extraSmall:
        fontSize = fontSizeExtraSmall;
        break;
      case OBAvatarSize.small:
        fontSize = fontSizeSmall;
        break;
      case OBAvatarSize.medium:
        fontSize = fontSizeMedium;
        break;
      case OBAvatarSize.large:
        fontSize = fontSizeLarge;
        break;
      case OBAvatarSize.extraLarge:
        fontSize = fontSizeExtraLarge;
        break;
    }

    return fontSize;
  }
}
