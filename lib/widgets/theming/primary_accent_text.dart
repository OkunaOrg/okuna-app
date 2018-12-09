import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBPrimaryAccentText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final OBTextSize size;
  final TextOverflow overflow;
  final int maxLines;

  OBPrimaryAccentText(this.text,
      {this.style,
      this.size,
      this.maxLines,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    var themeService = OpenbookProvider.of(context).themeService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          TextStyle finalStyle = style;
          TextStyle themedTextStyle =
              TextStyle(color: Pigment.fromString(theme.primaryAccentColor));

          if (finalStyle != null) {
            finalStyle = finalStyle.merge(themedTextStyle);
          } else {
            finalStyle = themedTextStyle;
          }

          return OBText(
            text,
            style: finalStyle,
            size: size,
            overflow: overflow,
            maxLines: maxLines,
          );
        });
  }
}
