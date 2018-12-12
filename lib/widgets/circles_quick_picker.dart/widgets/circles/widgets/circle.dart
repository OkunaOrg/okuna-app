import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/circles_picker/widgets/circles_search_results.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBCircle extends StatelessWidget {
  final bool isSelected;
  final Circle circle;
  final OnCirclePressed onCirclePressed;

  OBCircle(this.circle, {this.onCirclePressed, this.isSelected});

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

          Color activeColor = themeValueParserService
              .parseGradient(theme.primaryAccentColor)
              .colors[0];

          double circleSize = 40;
          return GestureDetector(
            onTap: () {
              if (this.onCirclePressed != null) {
                this.onCirclePressed(circle);
              }
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 70),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: circleSize,
                    width: circleSize,
                    decoration: BoxDecoration(
                        color: Pigment.fromString(circle.color),
                        border: Border.all(
                            color: isSelected
                                ? activeColor
                                : Color.fromARGB(10, 0, 0, 0),
                            width: 3),
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  OBText(
                    circle.name,
                    size: OBTextSize.small,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        });
  }
}

