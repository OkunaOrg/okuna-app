import 'package:Openbook/models/circle.dart';
import 'package:Openbook/widgets/circle_color_preview.dart';
import 'package:Openbook/widgets/circles_picker/widgets/circles_search_results.dart';
import 'package:Openbook/widgets/fields/checkbox_field.dart';
import 'package:flutter/material.dart';

class OBCircleSelectableTile extends StatelessWidget {
  final Circle circle;
  final OnCirclePressed onCirclePressed;
  final bool isSelected;

  const OBCircleSelectableTile(this.circle,
      {Key key, this.onCirclePressed, this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int usersCount = circle.usersCount;

    return OBCheckboxField(
      value: isSelected,
      title: circle.name,
      subtitle: '$usersCount people',
      onTap: () {
        onCirclePressed(circle);
      },
      leading: Container(
        height: 40,
        width: 40,
        child: Center(
          child: OBCircleColorPreview(
            circle,
            size: OBCircleColorPreviewSize.small,
          ),
        ),
      ),
    );
  }
}
