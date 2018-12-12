import 'package:Openbook/models/circle.dart';
import 'package:Openbook/models/theme.dart';
import 'package:Openbook/provider.dart';
import 'package:Openbook/widgets/circles_picker/widgets/circles_search_results.dart';
import 'package:Openbook/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBCircleColorPreview extends StatelessWidget {
  final bool isSelected;
  final Circle circle;
  final OBCircleColorPreviewSize size;

  OBCircleColorPreview(this.circle,
      {this.isSelected = false, this.size = OBCircleColorPreviewSize.medium});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
          var themeService = openbookProvider.themeService;
          var themeValueParserService = openbookProvider.themeValueParserService;

          double circleSize = _getCircleSize(size);

          return StreamBuilder(
              stream: themeService.themeChange,
              initialData: themeService.getActiveTheme(),
              builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
                var theme = snapshot.data;

                Color activeColor = themeValueParserService
                    .parseGradient(theme.primaryAccentColor)
                    .colors[0];

          return Container(
            height: circleSize,
            width: circleSize,
            decoration: BoxDecoration(
                color: Pigment.fromString(circle.color),
                border: Border.all(
                    color:
                        isSelected ? activeColor : Color.fromARGB(10, 0, 0, 0),
                    width: 3),
                borderRadius: BorderRadius.circular(50)),
          );
        });
  }

  double _getCircleSize(OBCircleColorPreviewSize size) {
    double circleSize;

    switch (size) {
      case OBCircleColorPreviewSize.medium:
        circleSize = 40;
        break;
      case OBCircleColorPreviewSize.small:
        circleSize = 15;
        break;
    }

    return circleSize;
  }
}

enum OBCircleColorPreviewSize { small, medium }
