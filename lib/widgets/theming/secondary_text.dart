import 'package:Okuna/models/theme.dart';
import 'package:Okuna/provider.dart';
import 'package:Okuna/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBSecondaryText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final OBTextSize size;
  final TextOverflow overflow;
  final TextAlign textAlign;

  const OBSecondaryText(this.text,
      {this.style, this.size, this.overflow, this.textAlign});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          TextStyle finalStyle = themeService.getDefaultTextStyle().merge(
              TextStyle(
                  color: themeValueParserService
                      .parseColor(theme.secondaryTextColor)));

          if (style != null) {
            finalStyle = style.merge(finalStyle);
          }

          return OBText(
            text,
            style: finalStyle,
            size: size,
            overflow: overflow,
            textAlign: textAlign,
          );
        });
  }
}
