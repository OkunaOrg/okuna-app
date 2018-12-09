import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBPrimaryText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int maxLines;
  final OBPrimaryTextSize size;

  OBPrimaryText(this.text,
      {this.style,
      this.textAlign,
      this.overflow,
      this.maxLines,
      this.size = OBPrimaryTextSize.medium});

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;
    double fontSize;

    switch (size) {
      case OBPrimaryTextSize.small:
        fontSize = 12;
        break;
      case OBPrimaryTextSize.medium:
        fontSize = 16;
        break;
      case OBPrimaryTextSize.large:
        fontSize = 18;
        break;
      case OBPrimaryTextSize.extraLarge:
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

enum OBPrimaryTextSize { small, medium, large, extraLarge }
