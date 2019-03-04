import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OBRichText extends StatelessWidget {
  final List<TextSpan> children;
  final OBTextSize size;
  final GestureRecognizer recognizer;

  const OBRichText(
      {this.size = OBTextSize.medium,
      @required this.children,
      this.recognizer});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    double fontSize = OBText.getTextSize(size);

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          TextStyle textStyle = TextStyle(
              color: themeValueParserService.parseColor(theme.primaryTextColor),
              fontSize: fontSize);

          return RichText(
            text: TextSpan(
                style: textStyle, children: children, recognizer: recognizer),
          );
        });
  }
}
