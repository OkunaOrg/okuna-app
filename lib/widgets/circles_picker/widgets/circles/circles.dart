import 'package:Openbook/models/circle.dart';
import 'package:Openbook/widgets/circles_picker/widgets/circles/widgets/circle.dart';
import 'package:flutter/material.dart';

class OBCircles extends StatelessWidget {
  final OnCirclePressed onCirclePressed;
  final List<Circle> circles;
  final List<Circle> selectedCircles;

  OBCircles(this.circles,
      {@required this.onCirclePressed, @required this.selectedCircles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: circles.length,
        itemBuilder: (BuildContext context, index) {
          Circle circle = circles[index];
          bool isSelected = selectedCircles.contains(circle);
          return OBCircle(
            circle,
            onCirclePressed: onCirclePressed,
            isSelected: isSelected,
          );
        });
  }
}
