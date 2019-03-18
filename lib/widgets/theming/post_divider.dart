import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class OBPostDivider extends StatelessWidget {
  const OBPostDivider();

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

          Color color = themeValueParserService.parseColor(theme.primaryColor);

          TinyColor modifiedColor = themeValueParserService.isDarkColor(color)
              ? TinyColor(color).lighten(15)
              : TinyColor(color).darken(15);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: modifiedColor.color,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                height: 1.0,
              ),
            ),
          );
        });
  }
}
