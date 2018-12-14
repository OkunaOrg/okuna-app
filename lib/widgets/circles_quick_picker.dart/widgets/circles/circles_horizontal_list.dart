import 'package:Openbook/models/circle.dart';
import 'package:Openbook/widgets/circles_picker/widgets/circles_search_results.dart';
import 'package:Openbook/widgets/circles_quick_picker.dart/widgets/circles/widgets/circle_horizontal_list_item.dart';
import 'package:flutter/material.dart';

class OBCirclesHorizontalList extends StatelessWidget {
  final OnCirclePressed onCirclePressed;
  final List<Circle> circles;
  final List<Circle> selectedCircles;
  final List<Circle> disabledCircles;

  OBCirclesHorizontalList(this.circles,
      {@required this.onCirclePressed,
      @required this.selectedCircles,
      @required this.disabledCircles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: circles.length,
      itemBuilder: (BuildContext context, int index) {
        var circle = circles[index];
        bool isSelected = selectedCircles.contains(circle);
        bool isDisabled = disabledCircles.contains(circle);

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
          ),
          child: OBCircleHorizontalListItem(circle,
              onCirclePressed: onCirclePressed,
              isSelected: isSelected,
              isDisabled: isDisabled),
        );
      },
    );
  }
}
