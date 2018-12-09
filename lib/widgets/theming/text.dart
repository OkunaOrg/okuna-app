import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;
  final OBTextSize size;

  OBText(this.text,
      {this.style,
      this.textAlign,
      this.overflow,
      this.maxLines,
      this.size = OBTextSize.medium});

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;
    double fontSize;

    switch (size) {
      case OBTextSize.small:
        fontSize = 12;
        break;
      case OBTextSize.medium:
        fontSize = 16;
        break;
      case OBTextSize.large:
        fontSize = 18;
        break;
      case OBTextSize.extraLarge:
        fontSize = 30;
    }

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          TextStyle themedTextStyle = TextStyle(
              color: Pigment.fromString(theme.primaryTextColor),
              fontSize: (style != null && style.fontSize != null)
                  ? style.fontSize
                  : fontSize);

          if (style != null) {
            themedTextStyle = themedTextStyle.merge(style);
          }

          return Text(
            text,
            style: themedTextStyle,
            overflow: overflow,
            maxLines: maxLines,
            textAlign: textAlign,
          );
        });
  }
}

enum OBTextSize { small, medium, large, extraLarge }
