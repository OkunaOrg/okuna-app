import 'package:Openbook/models/circle.dart';
import 'package:Openbook/pages/home/bottom_sheets/connection_circles_picker.dart';
import 'package:flutter/material.dart';

class BottomSheetService {
  void showConnectionsCirclesPicker(
      {@required BuildContext context,
      @required String title,
      @required String actionLabel,
      @required OnPickedCircles onPickedCircles,
      List<Circle> initialPickedCircles}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return OBConnectionCirclesPickerBottomSheet(
            initialPickedCircles: initialPickedCircles,
            title: title,
            actionLabel: actionLabel,
            onPickedCircles: onPickedCircles,
          );
        });
  }
}
