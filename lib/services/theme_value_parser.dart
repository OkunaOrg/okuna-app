import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:pigment/pigment.dart';

class ThemeValueParserService {
  static AlignmentGeometry _beginAlignment = Alignment.topLeft;
  static AlignmentGeometry _endAlignment = Alignment.bottomRight;

  Color parseColor(String value) {
    return Pigment.fromString(value);
  }

  Gradient parseGradient(String gradientValue) {
    List<String> gradients = gradientValue.split(',');

    if (gradients.length == 1) {
      gradients.add(gradients[0]);
    }

    List<Color> colors =
        gradients.map((colorValue) => parseColor(colorValue)).toList();

    return LinearGradient(
        begin: _beginAlignment,
        end: _endAlignment,
        colors: colors,
        tileMode: TileMode.mirror);
  }
}
